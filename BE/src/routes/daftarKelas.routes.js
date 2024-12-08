const express = require('express');
const router = express.Router();
const kelasController = require('../controller/daftarKelas.controller');
const verifyJWT = require('../middleware/verifyJWT');

router.get("/getAllKelas", kelasController.getAllKelas);
router.post("/tambahKelas", verifyJWT, kelasController.addKelas);
router.patch("/ubahHariKelas/:id_kelas", verifyJWT, kelasController.editHariKelas);
router.patch("/ubahJumlahAnggota/:id_kelas", verifyJWT, kelasController.ubahJumlahAnggota);
router.delete("/deleteKelas/:id_kelas",verifyJWT, kelasController.deleteKelas);

module.exports = router;