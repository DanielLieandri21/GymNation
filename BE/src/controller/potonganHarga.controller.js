const potongaHargaModel = require("../model/potongan_harga");

const getPotonganHarga = async (req, res) => {
  try {
    const [data] = await potongaHargaModel.getAllPotonganHarga();
    if (data.length > 0) {
      res
        .status(200)
        .json({ message: "menampilkan data semua potongan harga", data: data });
    } else {
      res.json({
        massage: "Tidak ada potongan harga",
      });
    }
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "error menampilkan potongan harga" });
  }
};

const addPotonganHarga = async (req, res) => {
  const { title, jumlah_diskon } = req.body;
  try {
    await potongaHargaModel.addPotonganHarga(title, jumlah_diskon);
    res
      .status(200)
      .json({ success: true, message: "tambah potongann harga berhasil" });
  } catch (error) {
    console.log(error);
    res
      .status(500)
      .json({ success: true, message: "tambah potongann harga gagal" });
  }
}
;
const deletePotonganHarga = async (req, res) => {
  const { id_potongan_harga } = req.params;
  try {
    await potongaHargaModel.deletePotonganHarga(id_potongan_harga);
    res
      .status(200)
      .json({ success: true, message: "potongann harga berhasil dihapus" });
  } catch (error) {
    console.log(error);
    res
      .status(500)
      .json({ success: true, message: "tambah potongann harga gagal dihapus" });
  }
};


module.exports = {
    getPotonganHarga,
    addPotonganHarga,
    deletePotonganHarga,
}
