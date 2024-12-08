const conn = require('../config/database.config');

const getAllKelas = () => {
    const SQLQuery = "SELECT * FROM daftar_kelas"
    return conn.execute(SQLQuery)
}

const addDaftarKelas = (namaKelas, jadwal, jumlah_anggota, pelatih) => {
    const SQLQuery = "INSERT INTO daftar_kelas (nama_kelas, jadwal , jumlah_anggota, pelatih) VALUES (?, ?, ?, ?)"
    return conn.execute(SQLQuery, [namaKelas, jadwal, jumlah_anggota, pelatih]);
}

const deleteDaftarKelas = (id) => {
    const SQLQuery = "DELETE FROM daftar_kelas WHERE id_kelas = ?";
    return conn.execute(SQLQuery, [id]);
}

const ubahJumlahAnggota = (jumlah_anggota, id) => {
    const SQLQuery = "UPDATE daftar_kelas SET jumlah_anggota = ? WHERE id_kelas = ?"
    return conn.execute(SQLQuery, [jumlah_anggota, id])
}

const editHariKelas = (hari, id) => {
    const SQLQuery = "UPDATE daftar_kelas SET jadwal = ? WHERE id_kelas = ?"
    return conn.execute(SQLQuery, [hari, id])
}

module.exports = {
    getAllKelas,
    addDaftarKelas,
    deleteDaftarKelas,
    ubahJumlahAnggota,
    editHariKelas,
}
