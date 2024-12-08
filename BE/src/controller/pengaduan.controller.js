const pengaduanModel = require("../model/pengaduan");

const addPengaduan = async (req, res) => {
  const { nama, email, no_telpon, pesan } = req.body;

  try {
    await pengaduanModel.addPengaduan(nama, email, no_telpon, pesan);
    res.status(200).json({
      success: true,
      message: "pengaduan berhasil ditambahkan",
    });
  } catch (error) {
    res
      .status(500)
      .json({ success: false, message: "Server error", error: error.message });
  }
};

const getAllpengaduan = async (req, res) => {
  try {
    const [data] = await pengaduanModel.getAllpengaduan();

    if (data.length > 0) {
      res
        .status(200)
        .json({ message: "menampilkan semua pengaduan", data: data });
    } else {
      res.json({
        massage: "Tidak ada data pengaduan",
      });
    }
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

const deletePengaduan = async (req, res) => {
  const { id_pengaduan } = req.params;
  try {
    const result = await pengaduanModel.deletePengaduan(id_pengaduan);
    if (result[0].affectedRows === 0) {
      return res
        .status(404)
        .json({ succes: false, message: "data pengajuan tidak ditemukan" });
    }
    res.status(200).json({ succes: true, message: "data pengajuan dihapus" });
  } catch (error) {
    res
      .status(500)
      .json({ succes: false, message: "Server error", error: error.message });
  }
};

module.exports = {
  addPengaduan,
  getAllpengaduan,
  deletePengaduan,
};
