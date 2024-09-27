const express = require("express");
const router = express.Router();
const UserInfoHandler = require("../Handler/UserInfoHandler");

const user_info_handler = new UserInfoHandler();

router.get("/:id", (req, res) => {
    user_info_handler.create_user(req, res);
});

module.exports = router;