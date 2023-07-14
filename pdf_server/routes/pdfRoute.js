const express = require("express");
const router = express.Router();
const pdfController = require("../controllers/pdfController");
const { verifyToken } = require("../utils/middlewares");

const rateLimit = require("express-rate-limit");

const requestRateLimiter = rateLimit({
    windowMs: 2000, // 15 min in milliseconds
    max: 5,
    message: `Too many requests from this IP, please try again after 2 second`,
    statusCode: 429,
    headers: true,
});

router.post("/", requestRateLimiter, pdfController.createPdf);

router.get("/", verifyToken,requestRateLimiter, pdfController.findAllBooks);

router.get("/user/:id", verifyToken,requestRateLimiter, pdfController.findOneUser);

router.get("/book/:id", verifyToken,requestRateLimiter, pdfController.findOneBook);

router.delete("/book/:id", verifyToken, requestRateLimiter,pdfController.deleteOneBook);

router.post("/share/:id", verifyToken,requestRateLimiter, pdfController.shareBook);

module.exports = router;
