// /** Routes
//  * @module User
//  */

/**
 * @namespace User
 * @description Routes related to users
 */
const express = require("express");
const router = express.Router();
const UserInfoHandler = require("../Handler/UserInfoHandler");

const user_info_handler = new UserInfoHandler();

/**
 * @memberof User
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
 * @memberof User
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

/**
 * @memberof User
 * @name Get an user notification
 * @path {GET} user/:id/get-notification
 * @params {String} :id is the id of the user whose room we are trying to get.
 * @code {200} A valid notification
 * @code {400} Invalid username
 * @code {500} Backend error from the database
 * @response {JSON} All_Notifications list of Notification See description of the different status codes
 * @example Response: {
    "All_Notifications": [
        {
            "notification_id": "111-333"
            "from": "test@gmail.com"
            "msg": "hung@gmail.com requests to join your room",
            "type": "join-request"
        },
        {
            "notification_id": "111-444"
            "from": "test2@gmail.com"
            "msg": "dan@gmail.com invites luke@gmail.com to join their room",
            "type": "invite"
        }
    ]
}
 */
router.get("/:id/get-notification", (req, res) => {
    user_info_handler.get_user_notification(req, res);
});

/**
 * @memberof User
 * @name Get a notify message when user leave the room successfully
 * @path {GET} user/:id/leave-room
 * @params {String} :id is the id of the user whose room we are trying to get.
 * @code {200} A valid message
 * @code {400} This username is invalid
 * @code {404} User not found
 * @code {500} Backend error from the database
 * @response {String} message See description of the different status codes
 * @example
    If there is only one user in the room
        Response: { "message": "The room is being deleted and user leave the room successfully" }
If there is more than one user in the room
        Response: { "message": "User leave the room successfully" }
 */
router.get("/:id/leave-room", (req, res) => {
    user_info_handler.leave_user_room(req, res);
});

/**
 * @memberof User
 * @name Get a warning message when user want to leave the room
 * @path {GET} user/:id/leave-warning
 * @params {String} :id is the id of the user whose room we are trying to get.
 * @code {200} A valid message
 * @code {400} This username is invalid
 * @code {404} User not found
 * @code {500} Backend error from the database
 * @response {String} message See description of the different status codes
 * @example
    If there is only one user in the room
        Response: { "message": "Warning: If you leave, the room will be deleted!" }
If there is more than one user in the room
        Response: { "message": "Warning: Are you sure want to leave this room!" }
 */
router.get("/:id/leave-warning", (req, res) => {
    user_info_handler.get_user_warning(req, res);
});

/**
 * @memberof User
 * @name Get a message notify if you have roommate or not
 * @path {GET} user/:id/get-roommate
 * @params {String} :id is the id of the user whose room we are trying to get.
 * @code {200} A valid message
 * @code {400} This username is invalid
 * @code {404} User not found
 * @code {500} Backend error from the database
 * @response {String} message See description of the different status codes
 * @example
    If there is only one user in the room
        Response: { "message": "You have no roommate" }
If there is more than one user in the room
        Response: { "message": "You have at least one roommate" }
 */
router.get("/:id/get-roommate", (req, res) => {
    user_info_handler.get_roommate(req, res);
});

/**
 * @memberof User
 * @name Delete a notification of specific user
 * @path {Delete} user/:id/notification/:notif_id
 * @params {String} :id is the id of the user we are trying to get.
 * @params {String} :notif_id is the id of the notification from user with user id above
 * @code {200} A valid message
 * @code {400} This username is invalid
 * @code {400} The notification is is invalid
 * @code {404} User not found
 * @code {404} Notification not found
 * @code {500} Backend error from the database
 * @response {String} message See description of the different status codes
 * @example
    If notification exist for user
        Response: { "message": "Notification deleted successfully" }
If notification no longer or never exist for user
        Response: { "message": "Notification not found" }
 */
router.delete("/:id/notification/:notif_id", (req, res) => {
    user_info_handler.delete_notification(req, res);
});

router.use("/", (req, res) => {
    res.status(200).json({ Message: "Welcome to the User paths" });
});

module.exports = router;
