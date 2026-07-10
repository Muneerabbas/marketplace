const mongoose = require("mongoose");
const bcrypt = require("bcryptjs");

// A user has some basic info, a list of orders, and the products they uploaded.
const userSchema = new mongoose.Schema(
  {
    name: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },

    // Products this user is selling
    uploadedProducts: [{ type: mongoose.Schema.Types.ObjectId, ref: "Product" }],

    // Products this user bought
    orders: [{ type: mongoose.Schema.Types.ObjectId, ref: "Product" }],
  },
  { timestamps: true }
);

// Hash the password automatically before saving (only when it changed).
userSchema.pre("save", async function () {
  if (!this.isModified("password")) return;
  this.password = await bcrypt.hash(this.password, 10);
});

// Helper to check a login password against the stored hash.
userSchema.methods.checkPassword = function (plain) {
  return bcrypt.compare(plain, this.password);
};

// Never send the password back in API responses.
userSchema.set("toJSON", {
  transform: (doc, ret) => {
    delete ret.password;
    return ret;
  },
});

module.exports = mongoose.model("User", userSchema);
