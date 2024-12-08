require("dotenv").config();
const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");
const userModel = require("../model/user");

const login = async (req, res) => {
  const { email, password } = req.body;

  try {
    const [userRows] = await userModel.searchByEmail(email);
    if (userRows.length > 0) {
      const user = userRows[0];
      const match = await bcrypt.compare(password, user.password);
      if (match) {
        const token = jwt.sign({ id: user.id_user }, process.env.JWT_SECRET, {
          expiresIn: "2h",
        });
        return res.status(200).json({
          massage: "Login succesful",
          token,
        });
      }
    }
    return res.status(400).json({
      message: "Username or password is incorrect",
    });
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

const getUserLoggedIn = async (req, res) => {
  try {
    const response = await userModel.searchByID(req.id);
    if (!response) {
      return res.status(404).json({ message: "User not found", data: null });
    }
    res.status(200).json({ message: "User found", data: response });
  } catch (error) {
    res.status(500).json({ message: error.message, data: null });
  }
};

const logout = async (req, res) => {
  try {
      res.clearCookie('jwt', { 
          httpOnly: true,
          secure: false,
          sameSite: 'strict'
      });

      
      res.status(200).json({ 
          message: 'Logged out successfully',
          success: true 
      });
  } catch (error) {
      res.status(500).json({ 
          message: 'Logout failed',
          success: false,
          error: error.message 
      });
  }
}

module.exports = {
  login,
  getUserLoggedIn,
  logout
}
