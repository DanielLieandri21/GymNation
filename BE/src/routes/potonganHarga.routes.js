const express = require('express');
const router = express.Router();
const potongaHargaController = require('../controller/potonganHarga.controller');
const verifyJWT = require('../middleware/verifyJWT');

router.get("/getAllPotonganHarga", potongaHargaController.getPotonganHarga);
router.post("/tambahPotonganHarga", verifyJWT, potongaHargaController.addPotonganHarga);
router.delete("/deletePotonganHarga/:id_potongan_harga", verifyJWT, potongaHargaController.deletePotonganHarga);

module.exports = router;