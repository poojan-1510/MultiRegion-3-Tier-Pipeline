const express = require("express");
const mysql = require("mysql2");
const app = express();

let db;

// Retry connection function to handle DB not ready yet
function connectWithRetry(retries = 10) {
    db = mysql.createConnection({
        host: process.env.DB_HOST,            // RDS endpoint
        user: process.env.DB_USER || "root",  // RDS username
        password: process.env.DB_PASSWORD || "password", // RDS password
        database: process.env.DB_NAME || "sampledb"      // Database name
    });

    db.connect(err => {
        if (err) {
            if (retries > 0) {
                console.log(`MySQL not ready, retrying in 5s... (${retries} attempts left)`, err.code);
                setTimeout(() => connectWithRetry(retries - 1), 5000);
            } else {
                console.error("Could not connect to MySQL:", err);
                process.exit(1);
            }
        } else {
            console.log("Connected to MySQL");
        }
    });
}

// Initialize connection
connectWithRetry();

// Routes

// "/" returns MySQL message
app.get("/", (req, res) => {
    db.query("SELECT 'Hello from MySQL!' AS message", (err, result) => {
        if (err) return res.json({ error: err });
        res.json(result[0]);
    });
});

// "/health" returns plain running text
app.get("/health", (req, res) => {
    res.send("Backend is running");
});

// "/api" returns MySQL message
app.get("/api", (req, res) => {
    db.query("SELECT 'Hello from MySQL!' AS message", (err, result) => {
        if (err) return res.json({ error: err });
        res.json(result[0]);
    });
});

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Backend running on port ${PORT}`));
