// @ts-nocheck
const express = require("express");
const morgan = require("morgan");
const cors = require("cors");
const cookieParser = require("cookie-parser");
const app = express();

const errorController = require("./controllers/errorController");
const appError = require("./utils/appError");

const pdfRouter = require("./routes/pdfRoute");

app.use(
  cors({
    origin: true,
    credentials: true,
  })
);

app.use(cookieParser());
app.use(express.json({ limit: "20mb" }));

if (process.env.NODE_ENV == "DEV") app.use(morgan("dev"));

app.use("/api/v1/pdf", pdfRouter);

app.get("/", (req, res) => {
  res.status(200).json({
    status: "success",
    ipAddress: req.ip,
    message: "Welcome to the API from pdf server",
  });
});

app.all("*", (req, res, next) => {
  next(
    new appError(
      `Can't find this route (${req.originalUrl}) on the server`,
      404
    )
  );
});

app.use(errorController);

module.exports = app;
