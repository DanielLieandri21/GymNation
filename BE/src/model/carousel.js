const conn = require('../config/database.config')

const getAllPost = () => {
    const SQLQuery = "SELECT * FROM carousel";
    return conn.execute(SQLQuery);
}

const getPostByID = (id_carousel) => {
    const SQLQuery = "SELECT * FROM carousel WHERE id_carousel = ?";
    return conn.execute(SQLQuery, [id_carousel]);
}

const addCarouselData = (img_path, title) => {
    const SQLQuery = "INSERT INTO carousel (img_path, title) VALUES (?, ?)";
    return conn.execute(SQLQuery, [img_path, title]);
}

const deleteCarouselData = (id_carousel) => {
    const SQLQuery = "DELETE FROM carousel WHERE id_carousel = ?";
    return conn.execute(SQLQuery, [id_carousel]);
}

module.exports = {
    getAllPost,
    getPostByID,
    addCarouselData,
    deleteCarouselData
}