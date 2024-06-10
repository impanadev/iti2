const mysql = require("mysql2");

const mysqlConnection = mysql.createConnection({
  host: "database-1.cny888s0maqb.us-east-1.rds.amazonaws.com",
  port: 3306,
  user: "admin",
  database: "iti",
  password: "adminroot11",
  multipleStatements: true,
});


mysqlConnection.connect((err) => {
  if (!err) {
    console.log("Connected");
  } else {
    console.log("Connection Failed",err);
  }
});

module.exports = mysqlConnection;