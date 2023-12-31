// @ts-nocheck
const dotenv = require("dotenv");
const mongoose = require("mongoose");
const colors = require("colors");

process.on("uncaughtException", (err) => {
  console.log("UNCAUGHT EXCEPTION! Shutting down...");
  console.log(err.name, err.message);
  process.exit(1);
});

// if (process.env.NODE_ENV == "production") {
//   dotenv.config({ path: ".env.production" });
// } else {
dotenv.config({ path: ".env" });
// }

const port = process.env.PORT || 4003;

const app = require("./app.js");
const DB = process.env.DATABASE_REMOTE || process.env.DATABASE_LOCAL;
const server = app.listen(port, () => {
  console.log(
    `App running on ${port} in ${process.env.NODE_ENV} mode....`.brightMagenta
  );
});

process.on("unhandledRejection", (err) => {
  console.log("UNHANDLED REJECTION! Shutting down...");
  console.log(err.name, err.message);
  server.close(() => {
    process.exit(1);
  });
});
