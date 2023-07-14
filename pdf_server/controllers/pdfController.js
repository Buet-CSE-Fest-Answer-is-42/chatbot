const appError = require("../utils/appError");
const catchAsync = require("../utils/catchAsync");
const jwt = require("jsonwebtoken");
const Pdf = require("../models/Pdf");
const { transpileModule } = require("typescript");

exports.createPdf = catchAsync(async (req, res, next) => {
  const { data } = req.body;
  const { title, description, keywords, owner, file } = data;
  console.log(req.body);
  if (!title || !description || !keywords || !owner) {
    return next(new appError("Please provide all fields", 400));
  }

  const pdf = await Pdf.create({
    title,
    description,
    keywords,
    file,
    owner,
  });
  res.status(201).json({
    status: "success",
    data: {
      pdf,
    },
  });
});

exports.findOneUser = catchAsync(async (req, res, next) => {
  const id = req.params.id;
  const pdfs = await Pdf.find({
    owner: id,
  });
  console.log(pdfs);
  res.json({
    pdfs,
  });
});

exports.findOneBook = catchAsync(async (req, res, next) => {
  const id = req.params.id;
  const pdf = await Pdf.findById(id);
  console.log(pdf);
  res.json({
    pdf,
  });
});

exports.findAllBooks = catchAsync(async (req, res, next) => {
  const q = req.query.q;
  const page = parseInt(req.query.page) || 1;
  const limit = parseInt(req.query.limit) || 7;

  let query = {
    isShared: true,
  };

  if (q) {
    query = {
      $or: [
        { title: { $regex: q, $options: "i" } },
        { keywords: { $elemMatch: { $regex: q, $options: "i" } } },
      ],
      isShared: true,
    };
  }

  const count = await Pdf.countDocuments(query);
  const totalPages = Math.ceil(count / limit);
  const skip = (page - 1) * limit;

  let pdfs = [];

  if (count > 0) {
    pdfs = await Pdf.find(query)
      .sort({ $natural: -1 })
      .skip(skip)
      .limit(limit)
      .exec();
  }

  res.json({
    pdfs,
    page,
    totalPages,
  });
});

exports.shareBook = catchAsync(async (req, res, next) => {
  const id = req.params.id;
  let pdf = await Pdf.findById(id);
  pdf.isShared = true;
  pdf.save();
  res.json({
    status: "success",
  });
});

exports.deleteOneBook = catchAsync(async (req, res, next) => {
  const id = req.params.id;
  await Pdf.findByIdAndDelete(id);
  res.json({
    status: "success",
  });
});
