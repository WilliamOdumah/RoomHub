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
     * The user persistence object used by the info handler.
     * @type {string}
     * @private
     */
    #user_persistence;

    /**
     * Create a new NotificationHandler object
     * @constructor
     */
    constructor() {
        this.#user_persistence = Services.get_user_persistence();
        this.#notification_persistence = Services.get_notification_persistence();
    }

    get_notification_persistence() {
        return this.#notification_persistence;
    }

    get_user_persistence() {
        return this.#user_persistence;
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

            // need to verify if sender and receiver exist in database and also sender have a room
            let sender = await this.#user_persistence.get_user(from);
            // currently we have only one type "Join-request"
            let room_id = await this.#user_persistence.get_room_id(to);
            let receiver = await this.#user_persistence.get_user(to);

            if (sender === null || receiver === null) {
                response.status(404).json({ message: "User not found" });
            }
            const type = request.body.type;

            const msg = this.generate_message(from, to, type);
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

            if (new_notification_status === "SUCCESS") {
                // assign new notification to both sender and receiver
                // await this.#user_persistence.update_user_notifications(notif_id, from);
                await this.#user_persistence.update_user_notifications(notif_id, to);
                response.status(200).json({ message: "Successfully Created the new notification" });
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
        if (type == "join-request") {
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
