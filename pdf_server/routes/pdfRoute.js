const express = require("express");
const router = express.Router();
const pdfController = require("../controllers/pdfController");

router.post("/", pdfController.createPdf);

module.exports = router;
