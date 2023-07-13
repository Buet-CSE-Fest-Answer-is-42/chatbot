const express = require("express");
const router = express.Router();
const catchAsync = require("../../utils/catchAsync");
const appError = require("../../utils/appError");

const { Configuration, OpenAIApi } = require("openai");

const apiKey = process.env.OPENAI_API_KEY;
const organizationId = process.env.OPENAI_ORG_KEY;

const configuration = new Configuration({
  organizationId: organizationId,
  apiKey: apiKey,
});

router.route("/").post(
  catchAsync(async (req, res, next) => {
    const { messages } = req.body;
    validateMessage(messages, next);

    const openai = new OpenAIApi(configuration);
    const gptResponse = await openai.createChatCompletion({
      model: "gpt-3.5-turbo",
      messages: req.body.messages,
    });
    console.log(gptResponse.data.choices);
    const data = {
      reply: gptResponse.data.choices[0].message.content,
    };
    res.status(200).json({
      status: "success",
      message: "Welcome to the API",
      data: data,
    });
  })
);

const validateMessage = (messages, next) => {
  if (!Array.isArray(messages))
    return next(new appError("Please provide a valid message", 400));
  if (!messages) {
    return next(new appError("Please provide a message", 400));
  }
  if (messages.length < 1) {
    return next(new appError("Please provide a message", 400));
  }
  for (let i = 0; i < messages.length; i++) {
    if (!messages[i].role) {
      return next(new appError("Please provide a role", 400));
    }
    if (!messages[i].content) {
      return next(new appError("Please provide a content", 400));
    }
  }
};

module.exports = router;
