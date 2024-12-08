const conn = require('../config/database.config')

const getAllFasilitas = () =>{
    const SQLQuery = "SELECT * FROM fasilitas"
    return conn.execute(SQLQuery);
}

const getAllFasilitasByID = (id) =>{
    const SQLQuery = "SELECT * FROM fasilitas WHERE id_fasilitas = ?"
    return conn.execute(SQLQuery, [id]);
}

const addFasilitas = (nama, img) =>{
    const SQLQuery = "INSERT INTO fasilitas (img_path, title) VALUES (?, ?)"
    return conn.execute(SQLQuery, [nama, img]);
}

const deleteFasilitas = (id) => {
    const SQLQuery = "DELETE FROM fasilitas WHERE id_fasilitas = ?";
    return conn.execute(SQLQuery, [id]);
}

module.exports = {
    getAllFasilitas,
    getAllFasilitasByID,
    addFasilitas,
    deleteFasilitas,
}


