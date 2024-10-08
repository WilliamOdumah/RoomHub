const Services = require("../Utility/Services");
const { v4: uuidv4 } = require("uuid");

/**
 * @module Handler
 */

/**
 * Represents the notification handler
 * @class
 */
class NotificationHandler {
    /**
     * The notification object used by the handler
     * @type {String}
     * @private
     */
    #notification_persistence;

    /**
     * Create a new NotificationHandler object
     * @constructor
     */
    constructor() {
        this.#notification_persistence = Services.get_notification_persistence();
    }

    get_notification_persistence() {
        return this.#notification_persistence;
    }

    /**
     * Check if the passed in message is valid
     * @param {String} msg "A string representing the message to be validated"
     * @returns {Boolean} "Returns true if valid message, return false if invalid"
     */
    #is_valid_msg(msg) {
        if (msg === "") {
            return false;
        }
        return true;
    }

    /**
     * Add a new notification to the persistence Layer
     * @async
     * @param {Express.request} request "Request received by the router"
     * @param {Express.response} response "Response to be sent back to the service that sent the original request"
     */
    async create_notification(request, response) {
        try {
            const notif_id = uuidv4();
            const status = "unread";
            const from = request.body.from;
            const to = request.body.to;

            // need to verify if sender and receiver exist in database
            let sender = await Services.get_user_persistence().get_user(from);
            let receiver = await Services.get_user_persistence().get_user(to);
            if (sender === null || receiver === null) {
                response.status(404).json({ message: "User not found" });
            }

            const type = request.body.type;
            const msg = this.generate_message(from, to, type);
            let room_id;
            if (type === "invite") {
                room_id = await Services.get_user_persistence().get_room_id(from);
            } else {
                room_id = await Services.get_user_persistence().get_room_id(from);
            }
            if (!this.#is_valid_msg(msg)) {
                // give a certain type of response
                response.status(400).json({ message: "Error Creating Notification - Message is empty" });
            }
            let new_notification_status = await this.#notification_persistence.generate_new_notification(
                notif_id,
                msg,
                status,
                from,
                to,
                type,
                room_id,
            );
            // assign new notification to both sender and receiver
            await Services.get_user_persistence().update_user_notifications(notif_id, from);
            await Services.get_user_persistence().update_user_notifications(notif_id, to);

            if (new_notification_status === "SUCCESS") {
                response.status(200).json({ message: "Successfully created the new notifcation" });
            } else {
                response.status(500).json({ message: "Retry creating the notification" });
            }
        } catch (error) {
            response.status(500).json({ message: error.message });
        }
    }

    /**
     * Create a message based on sender, receiver and type
     * @param {String} from "a sender ID"
     * @param {String} to "a receiver ID"
     * @param {String} type "a type of notification, for now we just have invite"
     * @returns {String} "notification message"
     */
    generate_message(from, to, type) {
        if (type === "invite") {
            return this.generate_invite_message(from, to);
        } else if (type == "join-request") {
            return this.generate_room_request_message(from);
        }
        return "";
    }

    /**
     * Create an invite message based on sender, receiver
     * @param {String} from "a sender ID"
     * @param {String} to "a receiver ID"
     * @returns {String} "notification invite message"
     */
    generate_invite_message(from, to) {
        return `${from} invites ${to} to join their room`;
    }

    /**
     * Create an invite message based on sender, receiver
     * @param {String} from "a sender ID"
     * @returns {String} "notification invite message"
     */
    generate_room_request_message(from) {
        return `${from} requests to join your room`;
    }
}

module.exports = NotificationHandler;
