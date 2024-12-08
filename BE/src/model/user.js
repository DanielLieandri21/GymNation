const conn = require('../config/database.config');
const bcrypt = require("bcrypt");

const getAllUser = () => {
    const SQLQuery = "SELECT * FROM user"
    return conn.execute(SQLQuery)
}

const addPelanggan = async (first_name, last_name, email, plainpassword, role) => {
    const saltRounds = 10;
    const hashedPass = await bcrypt.hash(plainpassword, saltRounds);
    const SQLQuery = "INSERT INTO user (first_name, last_name, email , password, role) VALUES (? ,?, ?, ?, ?)"
    return conn.execute(SQLQuery, [first_name, last_name, email, hashedPass, role]);
}

const addAdmin = async (first_name, last_name, email, plainpassword, role) => {
    const saltRounds = 10;
    const hashedPass = await bcrypt.hash(plainpassword, saltRounds);
    const SQLQuery = "INSERT INTO user (first_name, last_name, email , password, role) VALUES (? ,?, ?, ?, ?)"
    return conn.execute(SQLQuery, [first_name, last_name, email, hashedPass, role]);
}

const searchByID = async (id) => {
    const SQLQuery = "SELECT * FROM user WHERE id_user = ?";
    return conn.execute(SQLQuery, [id]);
}

const searchByEmail = async (email) => {
    const SQLQuery = "SELECT * FROM user WHERE email = ?";
    return conn.execute(SQLQuery, [email]);
}

const deleteUser = async (id) => {
    const SQLQuery = "DELETE FROM user WHERE id_user = ?";
    return conn.execute(SQLQuery, [id]);
};

const changePassword = async (id, newPassword) => {
    const saltRounds = 10;
    const hashedPass = await bcrypt.hash(newPassword, saltRounds);
    const SQLQuery = "UPDATE user SET password = ? WHERE id_user = ?"
    return conn.execute(SQLQuery, [hashedPass, id]);
}

const updateProfile = async (id, first_name, last_name, email) => {
    const SQLQuery = "UPDATE user SET first_name = ?, last_name = ?, email = ? WHERE id_user = ?"
    return conn.execute(SQLQuery, [first_name, last_name, email, id])
}

const updateProfilePict = async (id, img_path) => {
    const SQLQuery = "UPDATE user SET img_path = ? WHERE id_user = ?"
    return conn.execute(SQLQuery, [img_path, id])
}

module.exports = {
    getAllUser,
    addAdmin,
    addPelanggan,
    searchByID,
    searchByEmail,
    deleteUser,
    changePassword,
    updateProfile,
    updateProfilePict
}