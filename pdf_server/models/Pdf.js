const mongoose = require("mongoose");
const { type } = require("os");

const pdfSchema = new mongoose.Schema({
  title: {
    type: String,
    required: [true, "Please provide a title"],
  },
  description: {
    type: String,
    required: [true, "Please provide a description"],
  },
  keywords: [
    {
      type: String,
    },
  ],
  isShared: {
    type: Boolean,
    default: false,
  },
  file: {
    type: String,
    required: [true, "Please provide a file"],
  },
  owner: {
    type: String,
    required: [true, "Please provide a owner"],
  },
  createdAt: {
    type: Date,
    default: () => Date.now(),
  },
  updatedAt: {
    type: Date,
    default: () => Date.now(),
  },
});

const Pdf = mongoose.model("Pdf", pdfSchema);
module.exports = Pdf;
