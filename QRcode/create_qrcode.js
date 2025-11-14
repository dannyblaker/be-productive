// make-qr-svg.js
import { writeFileSync } from "node:fs";
import QRCode from "qrcode";

const text = "url"; // put your URL or text here

const svg = await QRCode.toString(text, {
  type: "svg",
  errorCorrectionLevel: "H", // L, M, Q, H
  margin: 2,                 // quiet zone modules
  width: 512,                // overall size in px (viewBox)
  color: { dark: "#000000", light: "#ffffff" }
});

writeFileSync("qr.svg", svg, "utf8");
console.log("Saved qr.svg");