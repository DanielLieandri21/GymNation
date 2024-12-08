const express = require('express');
const router = express.Router();
const makananSehatController = require('../controller/makananSehat.controller');
const multer = require("../middleware/multer");
const verifyJWT = require('../middleware/verifyJWT');

router.get("/getAllMakanan", makananSehatController.getAllDataMakanan);
router.post("/tambahMakanan", multer.single("makanansehat_img"), verifyJWT, makananSehatController.addMakananSehat);
router.delete("/deleteMakanan/:id_makanan", verifyJWT, makananSehatController.deleteMakananSehat);

module.exports = router;