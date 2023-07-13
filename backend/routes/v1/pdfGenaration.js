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
    let temp = JSON.parse(iteratePrompt);

    const base64 = await createPDF(temp);
    res.json({
      temp,
      base64,
    });
  })
);

const genarator = `provide me appropriate prompt(max. 10) messages serially from the story provided. it would help if you kept in mind that the prompts are used for an ai model that hates unsafe content. use the cute or soft parts of the story only. use no name of the characters. I want to create some beautiful images related to it only. Return the prompts as a JSON array where it should look like [{"prompt": prompt should be here, "caption": appropriate and short caption for the image generated with this prompt}] 
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
  const doc = new PDFDocument();

  doc.font("Helvetica-Bold");
  doc.fontSize(30);

  let pageCounter = 0;
  let imageCounter = 0;
  let textPage = doc;

  for (let i = 0; i < prompts.length; i++) {
    const promptText = prompts[i].caption;
    const buffer = await generateImage(promptText);

    if (imageCounter % 4 === 0 && imageCounter !== 0) {
      doc.addPage();
      textPage = doc;
      imageCounter = 0;
      pageCounter++;
    }

    if (imageCounter < 4) {
      const x = (imageCounter % 2) * 300;
      const y = Math.floor(imageCounter / 2) * 350;
      doc.image(buffer, x, y, { width: 250 });
    }

    if (pageCounter % 2 === 0 && imageCounter === 0) {
      textPage = doc.addPage();
    }

    textPage
      .text(promptText, { align: "center", continued: true })
      .font("Helvetica")
      .fontSize(20)
      .text(" is stylish and big!", { align: "center" });

    imageCounter++;
  }

  doc.end();
  const base64 = await toBase64(doc);
  return base64;
}
