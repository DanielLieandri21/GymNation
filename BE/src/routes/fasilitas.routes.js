const express = require('express');
const router = express.Router();
const fasilitasController = require('../controller/fasilitas.controller');
const multer = require("../middleware/multer");
const verifyJWT = require('../middleware/verifyJWT');

router.get("/getAllFasilitas", fasilitasController.getAllFasilitas);
router.post("/tambahFasilitas", multer.single("fasilitas_img"), verifyJWT, fasilitasController.addFasilitas);
router.delete("/deleteFasilitas/:id_fasilitas", verifyJWT, fasilitasController.deleteFasilitas);

module.exports = router;