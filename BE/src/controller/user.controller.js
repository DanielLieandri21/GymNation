const transporter = require("../config/mail.config");
const userModel = require("../model/user");
const jwt = require("jsonwebtoken");
const {
  getStorage,
  ref,
  uploadBytes,
  getDownloadURL,
  deleteObject,
} = require("firebase/storage");
const firebaseConfig = require("../config/firebase.config");
const path = require("path");

const addPelanggan = async (req, res) => {
  const { first_name, last_name, email, password } = req.body;
  const role = "pelanggan";

  try {
    const [cekUser] = await userModel.searchByEmail(email);

    if (cekUser.length > 0) {
      return res.status(400).json({
        message: "email sudah terdaftar",
        success: false,
      });
    }

    await userModel.addPelanggan(first_name, last_name, email, password, role);
    res.status(200).json({ message: "pelanggan registered successfully" });
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

const addUser = async (req, res) => {
  const { first_name, last_name, email, password, role } = req.body;

  try {
    const [cekUser] = await userModel.searchByEmail(email);

    if (cekUser.length > 0) {
      return res.status(400).json({
        message: "email sudah terdaftar",
        success: false,
      });
    }

    await userModel.addPelanggan(first_name, last_name, email, password, role);
    res.status(200).json({ message: "user registered successfully" });
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

const getAllUser = async (req, res) => {
  try {
    const [data] = await userModel.getAllUser();
    if (data.length > 0) {
      res
        .status(200)
        .json({ message: "menampilkan data semua user", data: data });
    } else {
      res.json({
        massage: "Tidak ada user terdaftar",
      });
    }
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

const changePassword = async (req, res) => {
  const { id_user, newPass } = req.body;
  try {
    await userModel.changePassword(id_user, newPass);
    res.json({
      success: true,
      massage: "password berhasil diubah",
    });
  } catch (error) {
    res
      .status(500)
      .json({ success: false, message: "Server error", error: error.message });
  }
};

const forgetPassword = async (req, res) => {
  const { email } = req.body;
  console.log(email);

  try {
    const [userRows] = await userModel.searchByEmail(email);
    const user = userRows[0];

    if (!user) {
      return res
        .status(404)
        .json({ success: false, message: "Email tidak ditemukan." });
    }

    const token = jwt.sign({ id: user.id_user }, process.env.JWT_SECRET, {
      expiresIn: "15m",
    });

    const resetLink = `http://127.0.0.1:8000/resetPassword/${token}`;

    const mailOptions = {
      from: process.env.AUTH_EMAIL,
      to: email,
      subject: "Reset Password",
      html: `
        <h2>Anda telah meminta untuk mengatur ulang password.
            Klik link berikut untuk mengatur ulang password Anda:</h2>
        <h3>Link ini hanya berlaku selama 15 menit.</h3>
        <a href="${resetLink}">${resetLink}</a>
      `,
    };

    await transporter.sendMail(mailOptions);
    res.status(200).json({
      success: true,
      token: token,
      message: "Email reset password telah dikirim.",
    });
  } catch (error) {
    console.error("Error mengirim email reset password:", error);
    res
      .status(500)
      .json({ success: false, message: "Server error", error: error.message });
  }
};

const deleteUser = async (req, res) => {
  const { id_user } = req.params;
  console.log(id_user);

  try {
    const result = await userModel.deleteUser(id_user);
    if (result[0].affectedRows === 0) {
      return res
        .status(404)
        .json({ succes: false, message: "data user tidak ditemukan" });
    }
    res.status(200).json({ succes: true, message: "data user dihapus" });
  } catch (error) {
    res
      .status(500)
      .json({ succes: false, message: "Server error", error: error.message });
  }
};

const updateProfile = async (req, res) => {
  const { id_user } = req.params;
  const { first_name, last_name, email } = req.body;

  try {
    await userModel.updateProfile(id_user, first_name, last_name, email);
    res.status(200).json({ succes: true, message: "data user diperbarui" });
  } catch (error) {
    console.log(error);
    res.status(500).json({
      message: "Terjadi kesalahan saat memperbarui profil.",
      succes: false,
      serverMessage: error.message,
    });
  }
};

const updateProfilePict = async (req, res) => {
  const { id_user } = req.params;
  const  profile_pict  = req.file;

  try {

    // Cari data user
    const [userData] = await userModel.searchByID(id_user);
    const found = userData[0];

    if (!found) {
      return res.status(404).json({ message: "User tidak ditemukan." });
    }
    
    const { img_path } = found;

    // Hapus gambar lama jika ada
    if (img_path) {
      const filePath = img_path.split("/o/")[1].split("?")[0];
      const decodedPath = decodeURIComponent(filePath);

      const { firebaseStorage } = await firebaseConfig();
      const fileRef = ref(firebaseStorage, decodedPath);

      try {
        await deleteObject(fileRef);
      } catch (err) {
        console.error("Gagal menghapus gambar lama:", err.message);
        return res.status(500).json({
          message: "Gagal menghapus gambar lama.",
          error: err.message,
        });
      }
    }

    // Unggah gambar baru
    const profilePictImgURL = await uploadNewProfilePicture(profile_pict);

    // Update ke database
    await userModel.updateProfilePict(id_user, profilePictImgURL);

    return res.status(200).json({
      message: "Foto profil berhasil diperbarui.",
      success: true,
      data: { profilePictImgURL },
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: "Server error", error: error.message });
  }
};

// Fungsi terpisah untuk mengunggah gambar baru
const uploadNewProfilePicture = async (profilePictFile) => {
  if (!profilePictFile) {
    throw new Error('File tidak valid');
  }

  const profilePictFileExtension = path.extname(profilePictFile.originalname);
  const profilePictFileOriginalName = path.basename(
    profilePictFile.originalname,
    profilePictFileExtension
  );
  const newProfilePictfileName = `${Date.now()}_${profilePictFileOriginalName}${profilePictFileExtension}`;

  const { firebaseStorage } = await firebaseConfig();
  const storageRef = ref(firebaseStorage, `GymNation/user-img/${newProfilePictfileName}`);

  const profilePictBuffer = profilePictFile.buffer;

  const resultProfilePict = await uploadBytes(storageRef, profilePictBuffer, {
    contentType: profilePictFile.mimetype,
  });

  return await getDownloadURL(resultProfilePict.ref);
};


module.exports = {
  addPelanggan,
  addUser,
  getAllUser,
  changePassword,
  forgetPassword,
  deleteUser,
  updateProfile,
  updateProfilePict
};
