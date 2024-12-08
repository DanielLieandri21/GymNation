const conn = require('../config/database.config');

const addMakananSehat = (img, title, deskripsi) =>{
    const SQLQuery = "INSERT INTO makanan_sehat (img_path, title, deskripsi) VALUES (?, ?, ?)"
    return conn.execute(SQLQuery, [img, title, deskripsi]);
}

const deleteMakananSehat = (id) => {
    const SQLQuery = "DELETE FROM makanan_sehat WHERE id_makanan = ?";
    return conn.execute(SQLQuery, [id]);
}

const getMakananByID = (id) =>{
    const SQLQuery = "SELECT * FROM makanan_sehat WHERE id_makanan = ?"
    return conn.execute(SQLQuery, [id]);
}

const getALLMakanan = () =>{
    const SQLQuery = "SELECT * FROM makanan_sehat"
    return conn.execute(SQLQuery);
}

module.exports = {
    addMakananSehat,
    deleteMakananSehat,
    getMakananByID,
    getALLMakanan,
}