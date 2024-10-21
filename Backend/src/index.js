const User = require("./router/User");
const Room = require("./router/Room");
const Notification = require("./router/Notification");

const express = require("express");
const cors = require("cors");
require("dotenv").config();

const app = express();
const port = 3001;
app.use(express.json());
app.use(cors());

app.use("/user", User);
app.use("/room", Room);
app.use("/notification", Notification);

app.get("/", async (req, res) => {
    console.log(req.body);
    res.status(200).json({ message: "we cooking rn" });
});

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});
