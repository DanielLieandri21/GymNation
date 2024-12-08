const conn = require('../config/database.config')

const getAllPotonganHarga = () => {
    const SQLQuery = "SELECT * FROM potongan_harga"
    return conn.execute(SQLQuery);
}
const addPotonganHarga = (nama, jumlah) =>{
    const SQLQuery = "INSERT INTO potongan_harga (title, jumlah_diskon) VALUES (?, ?)"
    return conn.execute(SQLQuery, [nama, jumlah]);
}

const deletePotonganHarga = (id) => {
    const SQLQuery = "DELETE FROM potongan_harga WHERE id_potongan_harga = ?";
    return conn.execute(SQLQuery, [id]);
}

module.exports = {
    getAllPotonganHarga,
    addPotonganHarga,
    deletePotonganHarga,
}