const express = require('express');
const router = express.Router();
const carouselController = require('../controller/carousel.controller');
const multer = require("../middleware/multer");
const verifyJWT = require('../middleware/verifyJWT');

router.post('/addCarousel', multer.single('carousel_img'), verifyJWT, carouselController.addCarouselData);
router.get('/getCarousel', carouselController.getAllCarouselData);
router.delete('/deleteCarousel/:id_carousel', verifyJWT, carouselController.deleteCarouselData);

module.exports = router;