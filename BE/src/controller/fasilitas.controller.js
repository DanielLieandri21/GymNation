const fasilitasModel = require("../model/fasilitas");
const {
    getStorage,
    ref,
    uploadBytes,
    getDownloadURL,
    deleteObject,
  } = require("firebase/storage");
  const firebaseConfig = require("../config/firebase.config");
  const path = require("path");

const getAllFasilitas = async (req, res) => {
  try {
    const [data] = await fasilitasModel.getAllFasilitas();
    if (data.length > 0) {
      res
        .status(200)
        .json({ message: "menampilkan data fasilitas", data: data });
    } else {
      res.json({
        massage: "data fasilitas tidak ada",
      });
    }
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

const addFasilitas = async (req, res) => {
  const { title } = req.body;
  const fasilitas_img = req.file;

  try {
    const { firebaseStorage } = await firebaseConfig();

    // Upload foto carousel
    const fasilitasImgFile = fasilitas_img;
    if (fasilitasImgFile) {
      const fasilitasImgExtension = path.extname(fasilitasImgFile.originalname);
      const carouselImgOriginalName = path.basename(
        fasilitasImgFile.originalname,
        fasilitasImgExtension
      );
      const newProfilePictfileName = `${Date.now()}_${carouselImgOriginalName}${fasilitasImgExtension}`;

      const storageRef = ref(
        firebaseStorage,
        `GymNation/fasilitas-img/${newProfilePictfileName}`
      );
      const fasilitasImgFileBuffer = fasilitasImgFile.buffer;

      const resultFasilitasImg = await uploadBytes(
        storageRef,
        fasilitasImgFileBuffer,
        {
          contentType: fasilitasImgFile.mimetype,
        }
      );
      var FasilitasImgDownloadURL = await getDownloadURL(
        resultFasilitasImg.ref
      );
      const RS = { title, FasilitasImgDownloadURL };

      await fasilitasModel.addFasilitas(FasilitasImgDownloadURL, title);

      res.status(200).json({
        message: "data fasilitas carousel berhasil di tambahkan.",
        success: true,
        data: RS,
      });
    }
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

const deleteFasilitas = async (req, res) => {
  const { id_fasilitas } = req.params;

  try {
    const [fasilitasData] = await fasilitasModel.getAllFasilitasByID(id_fasilitas);
    const found = fasilitasData[0];

    if (!found) {
      return res
        .status(404)
        .json({ message: "Data fasilitas atau gambar tidak ditemukan." });
    }

    const { img_path } = found;

    const filePath = img_path.split("/o/")[1].split("?")[0];
    const decodedPath = decodeURIComponent(filePath);

    const { firebaseStorage } = await firebaseConfig();
    const fileRef = ref(firebaseStorage, decodedPath);

    await deleteObject(fileRef);
    console.log("Gambar berhasil dihapus dari Firebase Storage.");

    await fasilitasModel.deleteFasilitas(id_fasilitas);
    console.log("Data fasilitas berhasil dihapus dari database.");

    res.status(200).json({
      message: "Data fasilitas berhasil dihapus",
      status: true,
    });
  } catch (error) {
    console.error("Error saat menghapus fasilitas:", error);
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

module.exports = {
  getAllFasilitas,
  addFasilitas,
  deleteFasilitas,
};
