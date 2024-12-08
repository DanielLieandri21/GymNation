const express = require('express');
const router = express.Router();
const authController = require('../controller/auth.controller');
const verifyJWT = require('../middleware/verifyJWT');

router.post('/login', authController.login);
router.get('/me', verifyJWT, authController.getUserLoggedIn);
router.get('/logout',authController.logout);

module.exports = router;