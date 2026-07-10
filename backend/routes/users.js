const express = require("express");
const router = express.Router();
const User = require("../models/User");

// Note: to create a user, use POST /api/auth/signup

// Get all users
// GET /api/users
router.get("/", async (req, res) => {
  const users = await User.find();
  res.json(users);
});

// Get one user with their orders and uploaded products filled in
// GET /api/users/:id
router.get("/:id", async (req, res) => {
  try {
    const user = await User.findById(req.params.id)
      .populate("uploadedProducts")
      .populate("orders");
    if (!user) return res.status(404).json({ error: "User not found" });
    res.json(user);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// Buy a product: add it to the user's orders
// POST /api/users/:id/orders   body: { productId }
router.post("/:id/orders", async (req, res) => {
  try {
    const user = await User.findByIdAndUpdate(
      req.params.id,
      { $push: { orders: req.body.productId } },
      { new: true }
    )
      .populate("uploadedProducts")
      .populate("orders");
    if (!user) return res.status(404).json({ error: "User not found" });
    res.json(user);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

module.exports = router;
