const User = require("../models/User");
const appError = require("../utils/appError");
const catchAsync = require("../utils/catchAsync");
const jwt = require("jsonwebtoken");
const sendMail = require("../utils/mail");

exports.createUser = catchAsync(async (req, res, next) => {
  console.log(req.body);

  const { name, email, password } = req.body;
  //   TODO make a validator for req.body

  if (!name || !email || !password) {
    return next(new appError("Please fill all the required fields", 400));
  }
  const existingUser = await User.findOne({ email: email });
  if (existingUser) {
    return next(new appError("User already exists", 409));
  }

  const user = await User.create({
    name,
    email,
    password,
  });
  const mail = {
    subject: "Welcome to BotBot",
    text: `Your OTP is ${user.otp}`,
    html: `<h1>Your OTP is ${user.otp}</h1>`,
  };
  await sendMail(user.email, mail);
  res.status(201).json({
    status: "success",
    data: {
      user,
    },
  });
});

exports.verifyUser = catchAsync(async (req, res, next) => {
  const { otp } = req.body;
  if (!otp) {
    return next(new appError("Please provide otp", 400));
  }
  const user = await User.findOne({ otp: otp });
  if (!user) {
    return next(new appError("Invalid otp", 401));
  }
  user.otp = null;
  await user.save();
  res.status(200).json({
    status: "success",
    data: {
      user,
    },
  });
});

exports.getUser = catchAsync(async (req, res, next) => {
  const invalidFields = { password: 0, createdAt: 0, updatedAt: 0 };
  const user = await User.findOne({ _id: req.params.id }, invalidFields);

  if (user) {
    res.status(200).json({
      status: "success",
      data: {
        user: user,
      },
    });
  } else {
    return next(new appError("No user found with this id", 401));
  }
});

exports.getAllUser = catchAsync(async (req, res, next) => {
  const invalidFields = { password: 0, createdAt: 0, updatedAt: 0 };
  const users = await User.find({}, invalidFields);

  res.status(200).json({
    status: "success",
    totalUser: users.length,
    data: {
      users,
    },
  });
});

exports.loginUser = catchAsync(async (req, res, next) => {
  const { email, password } = req.body;
  if (!email || !password) {
    return next(new appError("Please provide email and password", 400));
  }

  const user = await User.findOne({ email: email });
  if (!user) {
    return next(new appError("Invalid email or password", 401));
  }
  if (user.password !== password) {
    return next(new appError("Invalid email or password", 401));
  }
  const token = jwt.sign(
    { id: user._id, name: user.name, email: user.email },
    process.env.JWT_SECRET,
    {
      expiresIn: "1d",
    }
  );
  res.status(200).json({
    status: "success",
    token,
  });
});
