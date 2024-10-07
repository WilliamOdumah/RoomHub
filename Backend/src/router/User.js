/** Routes
 * @module User
 */
const express = require("express");
const router = express.Router();
const UserInfoHandler = require("../Handler/UserInfoHandler");

const user_info_handler = new UserInfoHandler();

/**
 *
 * @name Add a new user
 * @path {POST} user/add-user
 * @query {String} id The new users e-mail to be added to the database
 * @code {200} This user name already exist
 * @code {200} User Successfully created
 * @code {400} Error Creating User- User id is invalid
 * @code {500} Backend error from the database
 * @response {String} message See description of the different status codes
 */
router.post("/add-user", (req, res) => {
    user_info_handler.create_user(req, res);
});

/**
 * @name Get a users room name
 * @path {GET} user/:id/get-room
 * @params {String} :id is the id of the user whose room we are trying to get.
 * @code {200} NA
 * @code {200} A valid room name
 * @code {400} This username is invalid
 * @code {404} User not found
 * @code {500} Backend error from the database
 * @response {String} room_name See description of the different status codes
 */
router.get("/:id/get-room", (req, res) => {
    user_info_handler.get_user_room(req, res);
});

router.use("/", (req, res) => {
    res.status(200).json({ Message: "Welcome to the User paths" });
});

module.exports = router;
