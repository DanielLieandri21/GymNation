const daftarKelasModel = require("../model/daftar_kelas");

const getAllKelas = async (req, res) => {
  try {
    const [kelas] = await daftarKelasModel.getAllKelas();
    if (kelas.length > 0) {
      res
        .status(200)
        .json({ message: "menampilkan data semua kelas", data: kelas });
    } else {
      res.json({
        massage: "Tidak ada kelas terdaftar",
      });
    }
  } catch (error) {
    res.status(500).json({ message: "error menampilkan data semua kelas" });
  }
};

const addKelas = async (req, res) => {
  const { nama_kelas, jadwal, jumlah_anggota, pelatih } = req.body;

  try {
    await daftarKelasModel.addDaftarKelas(
      nama_kelas,
      jadwal,
      jumlah_anggota,
      pelatih
    );
    res.status(200).json({ success: true, message: "tambah kelas berhasil" });
  } catch (error) {
    console.log(error);
    res.status(500).json({ success: true, message: "tambah kelas gagal" });
  }
};

const ubahJumlahAnggota = async (req, res) => {
  const { jumlah_anggota } = req.body;
  const { id_kelas } = req.params;

  try {
    await daftarKelasModel.ubahJumlahAnggota(jumlah_anggota, id_kelas);
    res
      .status(200)
      .json({ success: true, message: "anggota baru berhasil ditambahkan" });
  } catch (error) {
    console.log(error);
    res
      .status(500)
      .json({ success: false, message: "anggota baru gagal ditambahkan" });
  }
};

const editHariKelas = async (req, res) => {
  const { id_kelas } = req.params;
  const { hari } = req.body;

  try {
    await daftarKelasModel.editHariKelas(hari, id_kelas);
    res
      .status(200)
      .json({ success: true, message: "jadwal kelas berhasil di edit" });
  } catch (error) {
    console.log(error);
    res
      .status(500)
      .json({ success: true, message: "jadwal kelas gagal di edit" });
  }
};

const deleteKelas = async (req, res) => {
  const { id_kelas } = req.params;

  try {
    await daftarKelasModel.deleteDaftarKelas(id_kelas);
    res
      .status(200)
      .json({ success: true, message: "jadwal kelas berhasil dihapus" });
  } catch (error) {
    console.log(error);
    res
      .status(500)
      .json({ success: true, message: "jadwal kelas gagal dihapus" });
  }
};

module.exports = {
    getAllKelas,
    addKelas,
    ubahJumlahAnggota,
    editHariKelas,
    deleteKelas
}