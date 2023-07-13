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
// Require the cloudinary library
const cloudinary = require("cloudinary").v2;

// Return "https" URLs by setting secure: true

cloudinary.config({
  cloud_name: "kongkacloud",
  api_key: "293739775524848",
  api_secret: "cHoLMYE8JKzbQR3inu_aLhXdVoc",
});

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
  catchAsync(async (req, res, next) => {
    const { story } = req.body;
    let genPrompt = `
    The story: ${"\n"}
    ${story}
    ${"\n"}
    The story ends here. ${"\n"}

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
    let temp = JSON.parse(iteratePrompt);

    const doc = await createPDF(temp);
    const result = await uploadImage(doc);

    const data = {
      title: "Title of the story",
      description: "Description of the story",
      file: result,
      owner: "random",
      category: ["tag1", "tag2"],
    };
    // const pdf = await axios.post(
    //   "http://localhost:/v1/pdf",
    //   {
    //     data,
    //   },
    //   {
    //     headers: {
    //       "Content-Type": "application/json",
    //     },
    //   }
    // );
    res.json({
      status: "success",
      data: data,
    });
  })
);

const genarator = `Write me a story strictly including 5 passages with 100-120 words without numbering or any heading of the passage itself from the prompt above. The story should look like an essay with a proper title.
Now generate prompts from the given story for a text-to-image model that can generate related and appropriate images from the given prompts. The prompt should maintain the serial of the passages and be used for an AI model that hates unsafe content. The prompts should be able to generate images that soothe a child's heart, with no names of any character of the story, and should be in a way that the images seem to be in a similar genre. Then create a JSON array. There must be 5 prompts for 5 passages. The JSON element will look like {"prompt": the prompt generated for each passage, "passage": the whole passage that the prompt was generated for} Reply me with the JSON array only with no other texts or anything else.
`;
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

async function createPDF(prompts) {
  let doc = new PDFDocument();
  doc.moveDown(20);
  doc.fontSize(25).text("Title", {
    align: "center",
  });

  doc.fontSize(25).text("Author name", {
    align: "center",
  });

  doc.fontSize(25);
  for (let i = 0; i < prompts.length; i++) {
    doc.addPage();
    doc.fontSize(25);
    const promptText = prompts[i].prompt;
    const buffer = await generateImage(promptText);

    // Center the image on the page
    // const imageWidth = 220; // Adjust as needed
    // const imageHeight = 300; // Adjust as needed
    // const x = (doc.page.width - imageWidth) / 2;
    // const y = (doc.page.height - imageHeight) / 2;
    doc.image(buffer);

    doc.addPage();
    doc.moveDown(10);
    doc.text(`${prompts[i].passage} `, {
      align: "center",
      indent: 30,
      height: 600,
      ellipsis: true,
    });
  }
  doc.end();
  const randomString = Math.random().toString(36).substring(7);
  doc.pipe(fs.createWriteStream(`a${randomString}.pdf`));
  return `a${randomString}.pdf`;
}
