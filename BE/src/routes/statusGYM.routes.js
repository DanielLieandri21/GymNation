const express = require('express');
const router = express.Router();
const statusGYMcontroller = require('../controller/statusGym.controller');
const verifyJWT = require('../middleware/verifyJWT');

router.get("/getStatusGYM", statusGYMcontroller.getStatus)
router.patch("/updateStatus", verifyJWT, statusGYMcontroller.updateStatusGYM);

module.exports = router