const express = require("express");
const Database = require('./database');
const amqp = require('amqplib');

require('dotenv').config();

const app = express();
app.use(express.json());

const databaseUrl = process.env.DATABASE_URL;
const db = new Database(databaseUrl);


(async () => {
  console.log("connecting with databse...")
  await db.connect();
  console.log("connected with databse...")
  await db.createLoggerTable();
  console.log("create logger table.")
  await db.close();
  console.log("close connection.")
})();

async function consumeFromQueue() {
  const connection = await amqp.connect("amqp://rabbitmq");
  const channel = await connection.createChannel();
  const queue = "logger";

  await channel.assertQueue(queue, {
    durable: true,
  });

  channel.consume(queue, async (msg) => {
    if (msg !== null) {
      const content = JSON.parse(msg.content.toString());
      const { message, user, level } = content;
      try {
        await db.connect();
       
        await db.insertLog(message, user, level);
        await db.close();
        
        console.log("saved a new log.")

      } catch (error) {
        console.error("Error saving log:", error);
      }
      channel.ack(msg);
    }
  });
}

app.listen(8004, () => {
  console.log("Log service listening on port 8004");
  consumeFromQueue();
});
