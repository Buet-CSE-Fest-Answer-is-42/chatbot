const express = require("express");
const userController = require("../controllers/userController");
const router = express.Router();
const rateLimit = require("express-rate-limit");

const loginRateLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 min in milliseconds
  max: 5,
  message: `Login error, you have reached maximum retries. Please try again after 30 minutes`,
  statusCode: 429,
  headers: true,
});

router
  .route("/")
  .post(loginRateLimiter,userController.createUser)
  .get(userController.getAllUser);

router.route("/login").post(loginRateLimiter, userController.loginUser);
router.route("/verify").post(userController.verifyUser);

router.route("/get/:id").get(userController.getUser);

module.exports = router;
