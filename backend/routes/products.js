const express = require("express");
const router = express.Router();
const Product = require("../models/Product");
const User = require("../models/User");

// Upload a new product
// POST /api/products   body: { name, category, price, description, location, icon, seller }
router.post("/", async (req, res) => {
  try {
    const product = await Product.create(req.body);

    // If a seller was given, also add this product to their uploaded list
    if (req.body.seller) {
      await User.findByIdAndUpdate(req.body.seller, {
        $push: { uploadedProducts: product._id },
      });
    }

    res.status(201).json(product);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// Get all products (optionally filter by ?category= or ?location=)
// GET /api/products
router.get("/", async (req, res) => {
  const filter = {};
  if (req.query.category) filter.category = req.query.category;
  if (req.query.location) filter.location = req.query.location;

  const products = await Product.find(filter).populate("seller", "name email");
  res.json(products);
});

// Get one product
// GET /api/products/:id
router.get("/:id", async (req, res) => {
  try {
    const product = await Product.findById(req.params.id).populate(
      "seller",
      "name email"
    );
    if (!product) return res.status(404).json({ error: "Product not found" });
    res.json(product);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

module.exports = router;
