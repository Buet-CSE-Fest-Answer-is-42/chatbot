const express = require("express");
const router = express.Router();
const pdfController = require("../controllers/pdfController");
const { verifyToken } = require("../utils/middlewares");

router.post("/",  pdfController.createPdf);

router.get("/", verifyToken, pdfController.findAllBooks);

router.get("/user/:id", verifyToken, pdfController.findOneUser);

router.get("/book/:id", verifyToken, pdfController.findOneBook);

router.delete("/book/:id", verifyToken, pdfController.deleteOneBook);

router.post("/share/:id", verifyToken, pdfController.shareBook);

module.exports = router;
