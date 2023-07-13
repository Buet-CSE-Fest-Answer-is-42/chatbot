const express = require("express");
const userController = require("../controllers/userController");
const router = express.Router();

router
  .route("/")
  .post(userController.createUser)
  .get(userController.getAllUser);

router.route("/login").post(userController.loginUser);
router.route("/verify").post(userController.verifyUser);

router.route("/get/:id").get(userController.getUser);

module.exports = router;
