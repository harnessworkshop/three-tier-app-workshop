require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');

const app = express();

// PostgreSQL connection configuration
console.log('Database connection config:', {
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    database: process.env.DB_NAME,
    port: process.env.DB_PORT,
    // Don't log the password
});

const pool = new Pool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT || 5432,
    database: process.env.DB_NAME,
    ssl: {
        rejectUnauthorized: false
    }
});

// Enable CORS for frontend
app.use(cors({
    origin: ['*'],
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization'],
    exposedHeaders: ['access-control-allow-origin', 'access-control-allow-credentials']
}));

// Add a middleware to ensure CORS headers are always set
app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', req.headers.origin || 'http://localhost:3000');
    res.header('Access-Control-Allow-Credentials', 'true');
    next();
});

// Parse JSON bodies
app.use(express.json());

// Sample data endpoint with database query
app.get('/api/data', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM data ORDER BY created_at DESC');
        
        if (result.rows.length > 0) {
            res.json({
                data: result.rows,
                timestamp: new Date().toISOString()
            });
        } else {
            res.json({
                message: "No data found in database",
                timestamp: new Date().toISOString()
            });
        }
    } catch (err) {
        console.error('Database query error:', err);
        res.status(500).json({
            message: "Error fetching data from database",
            error: err.message
        });
    }
});

// Add this new endpoint to initialize the database
app.post('/api/init-db', async (req, res) => {
    try {
        // Create table with integer columns
        await pool.query(`
            CREATE TABLE IF NOT EXISTS data (
                id SERIAL PRIMARY KEY,
                key INTEGER NOT NULL UNIQUE,
                value INTEGER NOT NULL UNIQUE,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        `);

        // Insert sample integer data
        await pool.query(`
            INSERT INTO data (key, value) VALUES 
                (1, 100),
                (2, 200),
                (3, 300)
            ON CONFLICT DO NOTHING
        `);

        res.json({ message: 'Database initialized successfully' });
    } catch (err) {
        console.error('Database initialization error:', err);
        res.status(500).json({
            message: 'Error initializing database',
            error: err.message
        });
    }
});

// Add this new endpoint to clear the database
app.post('/api/clear-db', async (req, res) => {
    try {
        // Delete all records from the data table
        await pool.query('DELETE FROM data');
        
        res.json({ 
            message: 'Database cleared successfully',
            timestamp: new Date().toISOString()
        });
    } catch (err) {
        console.error('Database clear error:', err);
        res.status(500).json({
            message: 'Error clearing database',
            error: err.message
        });
    }
});

// Move server creation to a separate function
const PORT = process.env.PORT || 5000;
let server;

const startServer = () => {
    server = app.listen(PORT, () => {
        console.log(`Server is running on port ${PORT}`);
    });
    return server;
};

// Only start the server if we're not in test mode
if (process.env.NODE_ENV !== 'test') {
    startServer();
}

module.exports = { app, startServer }; 