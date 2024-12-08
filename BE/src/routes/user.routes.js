const express = require('express');
const router = express.Router();
const userController = require('../controller/user.controller');
const verifyJWT = require('../middleware/verifyJWT');
const multer = require("../middleware/multer");

router.post('/addPelanggan', userController.addPelanggan);
router.post('/addUser', userController.addUser);
router.post('/changePassword', verifyJWT, userController.changePassword);
router.post('/forgetPassword', userController.forgetPassword);
router.get('/getAllUser', verifyJWT,userController.getAllUser);
router.delete('/deleteUser/:id_user', verifyJWT, userController.deleteUser);
router.put('/updateProfile/:id_user', verifyJWT, userController.updateProfile);
router.patch('/updateProfilePicture/:id_user', multer.single('profile_pict'), verifyJWT, userController.updateProfilePict);

module.exports = router;