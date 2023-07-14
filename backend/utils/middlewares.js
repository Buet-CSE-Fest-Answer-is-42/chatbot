const jwt = require("jsonwebtoken");
const appError = require("./appError");
const verifyToken = (req, res, next) => {
  const token = req.headers["authorization"];
  if (!token) {
    return next(new appError("Please provide token", 401));
  }
  const bearer = token.split(" ");
  const bearerToken = bearer[1];
  if (!bearerToken) {
    return next(new appError("Please provide token", 401));
  }
  try {
    const decoded = jwt.verify(bearerToken, process.env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (err) {
    return next(new appError("Invalid token", 401));
  }
};

module.exports = {
  verifyToken,
};
