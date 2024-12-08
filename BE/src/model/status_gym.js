const conn = require('../config/database.config')

const updateStatusGYM = (status) => {
    const SQLQuery = "UPDATE status_gym SET status = ?"
    return conn.execute(SQLQuery, [status]);
}

const getAllStatusGYM = () => {
    const SQLQuery = "SELECT * FROM status_gym"
    return conn.execute(SQLQuery);
}

module.exports = {
    updateStatusGYM,
    getAllStatusGYM
}