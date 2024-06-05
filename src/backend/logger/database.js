const { Client } = require("pg");

class Database {
  constructor(databaseUrl) {
    this.client = new Client({ connectionString: databaseUrl });
  }

  async connect() {
    try {
      await this.client.connect();
      console.log("Connected to the database");
    } catch (err) {
      console.error("Error connecting to the database", err.stack);
    }
  }

  async createLoggerTable() {
    const createTableQuery = `
      CREATE TABLE IF NOT EXISTS logger (
        id SERIAL PRIMARY KEY,
        message TEXT NOT NULL,
        user VARCHAR(100) NOT NULL,
        level VARCHAR(50) NOT NULL,
        timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `;
    try {
      await this.client.query(createTableQuery);
      console.log('Table "logger" is ready');
    } catch (err) {
      console.error("Error creating table", err.stack);
    }
  }

  async insertLog(message, user, level) {
    const insertLogQuery = `
      INSERT INTO logger (message, user, level)
      VALUES ($1, $2, $3)
      RETURNING id, timestamp
    `;
    try {
      const res = await this.client.query(insertLogQuery, [
        message,
        user,
        level,
      ]);
      console.log("Log inserted:", res.rows[0]);
      return res.rows[0];
    } catch (err) {
      console.error("Error inserting log", err.stack);
    }
  }

  async close() {
    try {
      await this.client.end();
      console.log("Database connection closed");
    } catch (err) {
      console.error("Error closing the database connection", err.stack);
    }
  }
}

module.exports = Database;
