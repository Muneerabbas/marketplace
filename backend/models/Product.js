const mongoose = require("mongoose");

// A product that someone uploaded to sell.
const productSchema = new mongoose.Schema(
  {
    name: { type: String, required: true },
    category: { type: String, required: true },
    price: { type: Number, required: true },
    description: { type: String, default: "" },
    location: { type: String, default: "" },
    icon: { type: String, default: "shippingbox.fill" },

    // Who is selling it
    seller: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Product", productSchema);
