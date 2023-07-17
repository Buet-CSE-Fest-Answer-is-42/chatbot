const express = require("express");
const router = express.Router();
const catchAsync = require("../../utils/catchAsync");
const appError = require("../../utils/appError");
const axios = require("axios");
const FormData = require("form-data");
const PDFDocument = require("pdfkit");
const { Base64Encode } = require("base64-stream");
const fs = require("fs");
const { Configuration, OpenAIApi } = require("openai");
const { jsPDF } = require("jspdf");

const cloudinary = require("cloudinary").v2;
const { verifyToken } = require("../../utils/middlewares");

const rateLimit = require("express-rate-limit");

const requestRateLimiter = rateLimit({
  windowMs: 1000, // 15 min in milliseconds
  max: 5,
  message: `Too many requests from this IP, please try again after 1 second`,
  statusCode: 429,
  headers: true,
});
const storageConfig = {
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINAY_API_SECRET,
}
cloudinary.config(storageConfig);

const uploadImage = async (imagePath) => {
  const options = {
    use_filename: true,
    unique_filename: false,
    overwrite: true,
  };

  try {
    // Upload the image
    const result = await cloudinary.uploader.upload(imagePath, options);

    return result.secure_url;
  } catch (error) {
    console.error(error);
  }
};
const apiKey = process.env.OPENAI_API_KEY;
const organizationId = process.env.OPENAI_ORG_KEY;

const configuration = new Configuration({
  organizationId: organizationId,
  apiKey: apiKey,
});

router.route("/").post(
  verifyToken,
  requestRateLimiter,
  catchAsync(async (req, res, next) => {
    const { story } = req.body;
    let genPrompt = `
    The story: ${"\n"}
    ${story}
    ${"\n"}
    ${"\n"}

    ${genarator}
    `;
    const prompt = {
      messages: [
        {
          role: "user",
          content: genPrompt,
        },
      ],
    };

    const openai = new OpenAIApi(configuration);
    const gptResponse = await openai.createChatCompletion({
      model: "gpt-3.5-turbo",
      messages: prompt.messages,
    });
    const iteratePrompt = gptResponse.data.choices[0].message.content;
    console.log(iteratePrompt);
    // let temp = JSON.parse(iteratePrompt);
    const temp = JSON.parse(iteratePrompt, (key, value) => {
      if (key === "socket" || key === "_httpMessage") {
        return undefined; // Skip circular references
      }
      return value;
    });
    const titlePrompt = {
      messages: [
        {
          role: "user",
          content: `
          ${story},
          ${"\n"}
          ${"\n"}
          ${titleGen}`,
        },
      ],
    };

    const titleResponse = await openai.createChatCompletion({
      model: "gpt-3.5-turbo",
      messages: titlePrompt.messages,
    });
    const title = titleResponse.data.choices[0].message.content;
    console.log(title);

    const keywordsGen = {
      messages: [
        {
          role: "user",
          content: `
          ${story},
          ${"\n"}
          ${"\n"}
          generate 3-4 keywords for the story. return me an array of keywords. each of the keywords must be a string.`,
        },
      ],
    };
    const keywordsResponse = await openai.createChatCompletion({
      model: "gpt-3.5-turbo",
      messages: keywordsGen.messages,
    });
    let keywords = keywordsResponse.data.choices[0].message.content;

    let doc;

    try {
      doc = await createPDF(temp, title);
    } catch (e) {
      return next(new appError("Something went wrong", 400));
    }

    const result = await uploadImage(doc);
    // muhit
    const data = {
      title: title,
      description: story,
      file: result,
      owner: req.user.id || "64b03058ed14692f0d734ed4",
      keywords: [keywords],
    };
    const pdf = await axios.post(
      "http://localhost:8000/pdf_server/api/v1/pdf",
      {
        data,
      },
      {
        headers: {
          "Content-Type": "application/json",
        },
      }
    );

    res.status(201).json({
      status: "success",
    });
  })
);

const genarator = `Now divide the story in passages. Each passage must contain 100-120 words. Generate prompts from each of the passage for a text-to-image model that can generate related and appropriate images from the given prompts. The prompt should maintain the serial of the passages and be used for an AI model that hates unsafe content. The prompts should be able to generate images that soothe a child's heart, with no names of any character of the story, and should be in a way that the images seem to be in a similar genre. Then create a JSON array. There must be one prompt for each passages. The JSON element will look like {"prompt": the prompt generated for each passage, "passage": the whole passage of the story that the prompt was generated for} Reply me with the JSON array only with no other texts or anything else.`;
const titleGen = `Generate an appropriate title for the story. It should not contain the word “title” itself.`;

async function generateImage(prompt) {
  const form = new FormData();
  form.append("prompt", prompt);

  try {
    const key = process.env.IMAGE_KEY;
    const response = await axios.post(
      "https://clipdrop-api.co/text-to-image/v1",
      form,
      {
        headers: {
          "x-api-key": key,
          ...form.getHeaders(),
        },
        responseType: "arraybuffer",
      }
    );

    const buffer = response.data;
    return buffer;
  } catch (error) {
    console.error("Error:", error.message);
  }
}

const toBase64 = (doc) => {
  return new Promise((resolve, reject) => {
    try {
      const stream = doc.pipe(new Base64Encode());

      let base64Value = "";
      stream.on("data", (chunk) => {
        base64Value += chunk;
      });

      stream.on("end", () => {
        // base64Value = `data:application/pdf;base64,${base64Value}`;
        resolve(base64Value);
      });
    } catch (e) {
      reject(e);
    }
  });
};

module.exports = router;

async function createPDF(prompts, title) {
  const doc = new jsPDF();
  doc.setFontSize(25);
  doc.setFont("times", "bold");
  var titleSplit = doc.splitTextToSize(title, 200);
  doc.text(15, 100, titleSplit);
  for (let i = 0; i < prompts.length; i++) {
    doc.addPage();
    let img = await generateImage(prompts[i].prompt);
    img = img.toString("base64");

    var splitPrompt = doc.splitTextToSize(prompts[i].prompt, 180);
    doc.text(15, 100, splitPrompt);
    doc.addPage();
    doc.addImage(img, "JPEG", 52, 74, 105, 148);
  }

  const randomString = Math.random().toString(36).substring(7);
  doc.save(`a${randomString}.pdf`);
  return `a${randomString}.pdf`;
}

// async function createPDF(prompts) {
//   let doc = new PDFDocument();
//   doc.moveDown(20);
//   doc.fontSize(25).text("Title", {
//     align: "center",
//   });

//   doc.fontSize(25).text("Author name", {
//     align: "center",
//   });

//   doc.fontSize(25);
//   for (let i = 0; i < prompts.length; i++) {
//     doc.addPage();
//     doc.fontSize(25);
//     const promptText = prompts[i].prompt;
//     const buffer = await generateImage(promptText);

//     // Center the image on the page
//     // const imageWidth = 220; // Adjust as needed
//     // const imageHeight = 300; // Adjust as needed
//     // const x = (doc.page.width - imageWidth) / 2;
//     // const y = (doc.page.height - imageHeight) / 2;
//     doc.image(buffer);

//     doc.addPage();
//     doc.moveDown(10);
//     doc.text(`${prompts[i].passage} `, {
//       align: "center",
//       indent: 30,
//       height: 600,
//       ellipsis: true,
//     });
//   }
//   doc.end();
//   const randomString = Math.random().toString(36).substring(7);
//   doc.pipe(fs.createWriteStream(`a${randomString}.pdf`));
//   return `a${randomString}.pdf`;
// }
