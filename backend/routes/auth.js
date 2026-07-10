const express = require("express");
const router = express.Router();
const jwt = require("jsonwebtoken");
const User = require("../models/User");

// Secret used to sign login tokens. In a real app keep this in an env variable.
const JWT_SECRET = "marketplace_secret_key";

// Make a token that proves who the user is.
function makeToken(user) {
  return jwt.sign({ id: user._id }, JWT_SECRET, { expiresIn: "7d" });
}

// Sign up (create a new account)
// POST /api/auth/signup   body: { name, email, password }
router.post("/signup", async (req, res) => {
  try {
    const { name, email, password } = req.body;

    if (!name || !email || !password) {
      return res.status(400).json({ error: "name, email and password are required" });
    }

    // Stop duplicate accounts
    const exists = await User.findOne({ email });
    if (exists) return res.status(400).json({ error: "Email already registered" });

    // Password gets hashed automatically in the model
    const user = await User.create({ name, email, password });

    res.status(201).json({ token: makeToken(user), user });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// Log in to an existing account
// POST /api/auth/login   body: { email, password }
router.post("/login", async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email });
    if (!user) return res.status(401).json({ error: "Invalid email or password" });

    const ok = await user.checkPassword(password);
    if (!ok) return res.status(401).json({ error: "Invalid email or password" });

    res.json({ token: makeToken(user), user });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

module.exports = router;
