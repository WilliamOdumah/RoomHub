const express = require("express");
const router = express.Router();

router.post("room/create-room", (req, res) => {
    console.log(req);
    console.log(res);
});
