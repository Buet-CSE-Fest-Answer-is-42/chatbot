const express = require("express");
const cors = require("cors");
const proxy = require("express-http-proxy");
const colors = require('colors');

const app = express();

app.use(cors());
app.use(express.json());

app.use("/auth_server", proxy("http://localhost:4001"));
app.use("/pdf_server", proxy("http://localhost:4002"));
app.use("/bot_server",proxy("http://localhost:4003"));

app.listen(8000, () => {
  console.log("Gateway is Listening to Port 8000".brightCyan);
});
