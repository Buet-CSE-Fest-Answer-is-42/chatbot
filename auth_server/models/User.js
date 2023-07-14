const mongoose = require("mongoose");
const bcrypt = require("bcrypt");

const userSchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, "A user must have a name"],
  },
  email: {
    type: String,
    unique: true,
    required: [true, "A user must have an email"],
  },
  password: {
    type: String,
    required: [true, "A user must have a password"],
  },
  createdAt: {
    type: Date,
    default: () => Date.now(),
  },
  // 4 digit otp
  otp: {
    type: String,
    default: () => Math.floor(1000 + Math.random() * 9000).toString(),
  },

  updatedAt: {
    type: Date,
    default: () => Date.now(),
  },
});

const User = mongoose.model("User", userSchema);
module.exports = User;
