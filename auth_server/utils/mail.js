const nodemailer = require("nodemailer");

const password = process.env.MAIL_PASSWORD;
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "moksedur.rahman.sohan@gmail.com",
    pass: password,
  },
});

async function sendMail(sendTo, mail) {
  try {
    const mailOptions = {
      from: "moksedur.rahman.sohan@gmail.com",
      to: sendTo,
      subject: mail.subject || "Cart-o",
      text: mail.text,
      html: mail.html,
    };
    const res = await transporter.sendMail(mailOptions);
    return res;
  } catch (err) {
    console.log(err);
    return err.message;
  }
}

module.exports = sendMail;
