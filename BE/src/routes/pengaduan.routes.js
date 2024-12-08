const pengaduanController = require("../controller/pengaduan.controller");
const express = require('express');
const verifyJWT = require("../middleware/verifyJWT");
const router = express.Router();

router.post("/addPengaduan", pengaduanController.addPengaduan);
router.get("/getAllLaporan", verifyJWT, pengaduanController.getAllpengaduan);
router.delete("/deletePengaduan/:id_pengaduan", verifyJWT, pengaduanController.deletePengaduan);

module.exports = router;