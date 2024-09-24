const express = require("express");
const app = express();
const cors = require("cors")

app.use(cors());

// define routes and API
app.use(express.json({ extended: false }));
