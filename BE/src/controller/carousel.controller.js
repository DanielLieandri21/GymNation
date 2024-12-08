const carouselModel = require("../model/carousel");
const {
  getStorage,
  ref,
  uploadBytes,
  getDownloadURL,
  deleteObject,
} = require("firebase/storage");
const firebaseConfig = require("../config/firebase.config");
const path = require("path");

const addCarouselData = async (req, res) => {
  const { title } = req.body;
  const carousel_img = req.file;

  try {
    const { firebaseStorage } = await firebaseConfig();

    // Upload foto carousel
    const carouselImgFile = carousel_img;
    if (carouselImgFile) {
      const carouselImgExtension = path.extname(carouselImgFile.originalname);
      const carouselImgOriginalName = path.basename(
        carouselImgFile.originalname,
        carouselImgExtension
      );
      const newProfilePictfileName = `${Date.now()}_${carouselImgOriginalName}${carouselImgExtension}`;

      const storageRef = ref(
        firebaseStorage,
        `GymNation/carousel-img/${newProfilePictfileName}`
      );
      const carouselImgFileBuffer = carouselImgFile.buffer;

      const resultCarouselImg = await uploadBytes(
        storageRef,
        carouselImgFileBuffer,
        {
          contentType: carouselImgFile.mimetype,
        }
      );
      var carouselImgDownloadURL = await getDownloadURL(resultCarouselImg.ref);
      const RS = { title, carouselImgDownloadURL };

      await carouselModel.addCarouselData(carouselImgDownloadURL, title);

      res.status(200).json({
        message: "data carousel berhasil di tambahkan.",
        success:true,
        data: RS,
      });
    }
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

const deleteCarouselData = async (req, res) => {
  const { id_carousel } = req.params;

  try {
    const [carouselData] = await carouselModel.getPostByID(id_carousel);
    const found = carouselData[0]

    if (!found) {
      return res
        .status(404)
        .json({ message: "Data carousel atau gambar tidak ditemukan." });
    }

    const { img_path } = found; 

    const filePath = img_path.split("/o/")[1].split("?")[0];
    const decodedPath = decodeURIComponent(filePath);

    const { firebaseStorage } = await firebaseConfig();
    const fileRef = ref(firebaseStorage, decodedPath);

    await deleteObject(fileRef);
    console.log("Gambar berhasil dihapus dari Firebase Storage.");

    await carouselModel.deleteCarouselData(id_carousel);
    console.log("Data carousel berhasil dihapus dari database.");

    res.status(200).json({
      message: "Data carousel berhasil dihapus",
      status: true,
    });
  } catch (error) {
    console.error("Error saat menghapus carousel:", error);
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

const getAllCarouselData = async (req, res) => {
  try {
    const [data] = await carouselModel.getAllPost();
    if (data.length > 0) {
      res
        .status(200)
        .json({ message: "menampilkan data carousel", data: data });
    } else {
      res.json({
        massage: "data carousel tidak ada",
      });
    }
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

module.exports = {
  addCarouselData,
  deleteCarouselData,
  getAllCarouselData,
};
