const makananSehatModel = require("../model/makanan_sehat");
const {
  getStorage,
  ref,
  uploadBytes,
  getDownloadURL,
  deleteObject,
} = require("firebase/storage");
const firebaseConfig = require("../config/firebase.config");
const path = require("path");

const getAllDataMakanan = async (req, res) => {
    try {
        const [data] = await makananSehatModel.getALLMakanan();
        if (data.length > 0) {
          res
            .status(200)
            .json({ message: "menampilkan data makanan", data: data });
        } else {
          res.json({
            massage: "data makanan tidak ada",
          });
        }
      } catch (error) {
        res.status(500).json({ message: "Server error", error: error.message });
      }
}

const addMakananSehat = async (req, res) => {
  const { title, deskripsi } = req.body;
  const makanansehat_img = req.file;

  try {
    const { firebaseStorage } = await firebaseConfig();

    // Upload foto carousel
    const makananSehatImgFile = makanansehat_img;
    if (makananSehatImgFile) {
      const makananSehatImgExtension = path.extname(
        makananSehatImgFile.originalname
      );
      const makananSehatOriginalName = path.basename(
        makananSehatImgFile.originalname,
        makananSehatImgExtension
      );
      const newMakananSehatName = `${Date.now()}_${makananSehatOriginalName}${makananSehatImgExtension}`;

      const storageRef = ref(
        firebaseStorage,
        `GymNation/makanan-img/${newMakananSehatName}`
      );
      const makananSehatImgFileBuffer = makananSehatImgFile.buffer;

      const resultMakananImg = await uploadBytes(
        storageRef,
        makananSehatImgFileBuffer,
        {
          contentType: makananSehatImgFile.mimetype,
        }
      );
      var MakananSehatDownloadURL = await getDownloadURL(resultMakananImg.ref);
      const RS = { MakananSehatDownloadURL, title, deskripsi };

      await makananSehatModel.addMakananSehat(
        MakananSehatDownloadURL,
        title,
        deskripsi
      );

      res.status(200).json({
        message: "data makanan berhasil di tambahkan.",
        success: true,
        data: RS,
      });
    }
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

const deleteMakananSehat = async (req, res) => {
  const { id_makanan } = req.params;

  try {
    const [makananData] = await makananSehatModel.getMakananByID(id_makanan);
    const found = makananData[0];

    if (!found) {
      return res
        .status(404)
        .json({ message: "Data makanan atau gambar tidak ditemukan." });
    }

    const { img_path } = found;

    const filePath = img_path.split("/o/")[1].split("?")[0];
    const decodedPath = decodeURIComponent(filePath);

    const { firebaseStorage } = await firebaseConfig();
    const fileRef = ref(firebaseStorage, decodedPath);

    await deleteObject(fileRef);
    await makananSehatModel.deleteMakananSehat(id_makanan);

    res.status(200).json({
      message: "Data makanan berhasil dihapus",
      status: true,
    });
  } catch (error) {
    console.error("Error saat menghapus Data makanan:", error);
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

module.exports = {
  addMakananSehat,
  deleteMakananSehat,
  getAllDataMakanan
};
