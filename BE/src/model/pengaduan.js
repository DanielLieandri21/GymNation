const conn = require('../config/database.config');

const getAllpengaduan = () => {
    const SQLQuery = "SELECT * FROM pengaduan"
    return conn.execute(SQLQuery)
}

const addPengaduan = (nama, email, no_telpon, pesan) => {
    const SQLQuery = "INSERT INTO pengaduan (nama, email, no_telpon, pesan) VALUES (?, ?, ?, ?)"
    return conn.execute(SQLQuery, [nama, email, no_telpon, pesan]);
}

const deletePengaduan = async (id) => {
    const SQLQuery = "DELETE FROM pengaduan WHERE id_pengaduan = ?";
    return conn.execute(SQLQuery, [id]);
};

module.exports = {
    getAllpengaduan,
    addPengaduan,
    deletePengaduan,
}