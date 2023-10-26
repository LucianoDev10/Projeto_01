// Para mysql2
const mysql = require('mysql2');

var pool = mysql.createPool({
    "user": "root",
    "password": "",
    "database": "mydb",
    "host": "localhost",
    "port": 3306
});

exports.pool = pool;

// Para mysql2/promise
const mysqlPromise = require('mysql2/promise');

const poolPromise = mysqlPromise.createPool({
    "user": "root",
    "password": "",
    "database": "mydb",
    "host": "localhost",
    "port": 3306
});

exports.poolPromise = poolPromise;
