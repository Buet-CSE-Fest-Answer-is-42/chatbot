const appError = require("../utils/appError");
const catchAsync = require("../utils/catchAsync");
const jwt = require("jsonwebtoken");
const Pdf = require("../models/Pdf");

exports.createPdf = catchAsync(async (req, res, next) => {
  const { title, description, keywords, owner, base64 } = req.body;
  if (!title || !description || !keywords || !owner) {
    return next(new appError("Please provide all fields", 400));
  }
  
  const pdf = await Pdf.create({
    title,
    description,
    keywords,
    file: base64,
    owner,
    base64,
  });
  res.status(201).json({
    status: "success",
    data: {
      pdf,
    },
  });
});
