const statusGYMmodel = require("../model/status_gym");

const updateStatusGYM = async (req, res) => {
  const { status } = req.body;

  try {
    await statusGYMmodel.updateStatusGYM(status);
    res
      .status(200)
      .json({
        message: `berhasil mengupdate status gym ${status}`,
        data: status,
      });
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "error mengupdate status" });
  }
};

const getStatus = async (req, res) => {
  try {
    const [data] = await statusGYMmodel.getAllStatusGYM();
    res.status(200).json({ message: `menampilkan status gym`, data: data });
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "error menampilkan status" });
  }
};

module.exports = {
    updateStatusGYM,
    getStatus
}