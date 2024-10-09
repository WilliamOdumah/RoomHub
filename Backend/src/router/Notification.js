/**
 * @namespace Notification
 * @description Routes related to notifications
 */
const express = require("express");
const router = express.Router();
const NotificationHander = require("../Handler/NotificationHandler");

const notification_handler = new NotificationHander();

/**
 * @memberof Notification
 * @name Create a new join-room-request notification
 * @path {POST} notification/join-room-request
 * @query {String} from The sender user ID
 * @query {String} to The receiver user ID
 * @query {String} type The type of notification: join-request or (more coming soon)
 * @code {200} Notification Successfully created
 * @code {404} Error Creating Notification - User not found
 * @code {400} Error Creating Notification - Message is empty
 * @code {500} Backend error from the database
 * @response {String} message See description of the different status codes
 */
router.post("/join-room-request", (req, res) => {
    notification_handler.create_notification(req, res);
});

router.use("/", (req, res) => {
    res.status(200).json({ message: "Welcome to the Notification paths" });
});

module.exports = router;
