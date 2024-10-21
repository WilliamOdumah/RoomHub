const Services = require("../Utility/Services");

/**
 * @module Handler
 */

/**
 * Represents the user information handler
 * @class
 *
 */
class UserInfoHandler {
    /**
     * The user persistence object used by the info handler.
     * @type {string}
     * @private
     */
    #user_persistence;
    /**
     * The room persistence object used by the info handler.
     * @type {string}
     * @private
     */
    #room_persistence;

    /**
     * The notificaion persistence object used by the info handler.
     * @type {string}
     * @private
     */
    #notification_persistence;

    /**
     * Create a new UserInfoHandler object
     * @constructor
     */
    constructor() {
        this.#user_persistence = Services.get_user_persistence();
        this.#room_persistence = Services.get_room_persistence();
        this.#notification_persistence = Services.get_notification_persistence();
    }

    get_user_persistence() {
        return this.#user_persistence;
    }

    get_room_persistence() {
        return this.#room_persistence;
    }

    get_notification_persistence() {
        return this.#notification_persistence;
    }
    /**
     *Check if the passed in user_id is valid
     * @param {String} user_id "A string representing the user_id to be validated"
     * @returns {Boolean} "Returns true if valid id, returns false if invalid"
     */
    #is_valid_id(user_id) {
        if (user_id.length === 0) {
            return false;
        }
        return true;
    }

    /**
     * Add a new user to the persistence Layer
     * @async
     * @param {Express.request} request "Request received by the router"
     * @param {Express.response} response "Response to be sent back to the service that sent the original request"
     * @returns {Express.response} "A response object which contains the response to the request."
     */
    async create_user(request, response) {
        try {
            const user_id = request.body.id.trim().toLowerCase();
            if (!this.#is_valid_id(user_id)) {
                // give a certain type of response
                return response.status(400).json({ message: "Error Creating User- User id is invalid" });
            }
            let result = await this.#user_persistence.save_new_user(user_id);
            return response.status(result.status).json({ message: result.message });
        } catch (error) {
            return response.status(500).json({ message: error.message });
        }
    }

    /**
     * Get a users room
     * @async
     * @param {Express.request} request "Request received by the router"
     * @param {Express.response} response "Response to be sent back to the service that sent the original request"
     * @returns {Express.response} "A response object which contains the response to the request."
     */
    async get_user_room(request, response) {
        try {
            let user_id = request.params.id.trim().toLowerCase();
            // validate user_id
            if (!this.#is_valid_id(user_id)) {
                response.status(400).json({ room_name: "This username is invalid" });
            } else {
                // if valid user id
                let user = await this.#user_persistence.get_user(user_id);
                if (user === null) {
                    response.status(404).json({ room_name: "User not found" });
                } else {
                    let room_id = user.room_id;
                    // The user doesn't have a room yet(no sql fields don't exist if they've never been created)
                    if (room_id === undefined) {
                        response.status(200).json({ room_name: "NA" });
                    } else {
                        const room_name = await this.#room_persistence.get_room_name(room_id);
                        response.status(200).json({ room_name: room_name });
                    }
                }
            }
        } catch (error) {
            response.status(500).json({ room_name: error.message });
        }
    }

    /**
     * Get a list of notification from specific existing user in the database
     * @param {Express.request} request "Request received by the router"
     * @param {Express.response} response "Response to be sent back to the service that sent the original request"
     */
    async get_user_notification(request, response) {
        try {
            let user_id = request.params.id.trim().toLowerCase();
            // validate user_id
            if (!this.#is_valid_id(user_id)) {
                response.status(400).json({ message: "This username is invalid" });
            } else {
                // if valid user id
                let user = await this.#user_persistence.get_user(user_id);
                if (user === null) {
                    response.status(404).json({ message: "User not found" });
                } else {
                    let notification = await this.#user_persistence.get_notification(user_id);
                    // convert set into array
                    let notif_list = [...notification];
                    let result = [];
                    for (let item of notif_list) {
                        // update the status of notification from unread to read
                        await this.#notification_persistence.update_notification_status(item);
                        let notif_item = await this.#notification_persistence.get_msg_type(item);
                        result.push(notif_item);
                    }
                    response.status(200).json({ All_Notifications: result });
                }
            }
        } catch (error) {
            response.status(500).json({ message: error.message });
        }
    }

    /**
     * Get a message notify user left the room
     * @async
     * @param {Express.request} request "Request received by the router"
     * @param {Express.response} response "Response to be sent back to the service that sent the original request"
     * @returns {Express.response} "A response object which contains the response to the request."
     */
    async leave_user_room(request, response) {
        try {
            let user_id = request.params.id.trim().toLowerCase();
            // validate user_id
            if (!this.#is_valid_id(user_id)) {
                response.status(400).json({ message: "This username is invalid" });
            } else {
                // if valid user id
                let user = await this.#user_persistence.get_user(user_id);
                if (user === null) {
                    response.status(404).json({ message: "User not found" });
                } else {
                    // get the room id from the given user
                    let room_id = await this.#user_persistence.get_room_id(user_id);
                    // get the total number of users in the room
                    let users = await this.#room_persistence.get_room_users(room_id);
                    let total_users = users.size;
                    // the room only have 1 user
                    if (total_users === 1) {
                        // delete room
                        await this.#room_persistence.delete_room(room_id);
                        // remove room_id from the specific user
                        await this.#user_persistence.remove_room_id(room_id, user_id);
                        response.status(200).json({
                            message: "The room is being deleted and user leave the room successfully",
                        });
                        // more than 1 user in the room
                    } else {
                        // remove user_id from the specific room
                        await this.#room_persistence.remove_user_id(user_id, room_id);
                        // remove room_id from the specific user
                        await this.#user_persistence.remove_room_id(room_id, user_id);
                        response.status(200).json({ message: "User leave the room successfully" });
                    }
                }
            }
        } catch (error) {
            response.status(500).json({ message: error.message });
        }
    }

    /**
     * Get a warning message if user want to leave the room
     * @async
     * @param {Express.request} request "Request received by the router"
     * @param {Express.response} response "Response to be sent back to the service that sent the original request"
     * @returns {Express.response} "A response message which contains the response to the request."
     */
    async get_user_warning(request, response) {
        try {
            let user_id = request.params.id.trim().toLowerCase();
            // validate user_id
            if (!this.#is_valid_id(user_id)) {
                response.status(400).json({ message: "This username is invalid" });
            } else {
                // if valid user id
                let user = await this.#user_persistence.get_user(user_id);
                if (user === null) {
                    response.status(404).json({ message: "User not found" });
                } else {
                    // get the room id from the given user
                    let room_id = await this.#user_persistence.get_room_id(user_id);
                    // get the total number of users in the room
                    let users = await this.#room_persistence.get_room_users(room_id);
                    let total_users = users.size;
                    // the room only have 1 user
                    if (total_users === 1) {
                        response.status(200).json({ message: "Warning: If you leave, the room will be deleted!" });
                        // more than 1 user in the room
                    } else {
                        response.status(200).json({ message: "Warning: Are you sure want to leave this room!" });
                    }
                }
            }
        } catch (error) {
            response.status(500).json({ message: error.message });
        }
    }

    /**
     * Get a message notify if you have roommate or not
     * @async
     * @param {Express.request} request "Request received by the router"
     * @param {Express.response} response "Response to be sent back to the service that sent the original request"
     * @returns {Express.response} "A response message which contains the response to the request."
     */
    async get_roommate(request, response) {
        try {
            let user_id = request.params.id.trim().toLowerCase();
            // validate user_id
            if (!this.#is_valid_id(user_id)) {
                response.status(400).json({ message: "This username is invalid" });
            } else {
                // if valid user id
                let user = await this.#user_persistence.get_user(user_id);
                if (user === null) {
                    response.status(404).json({ message: "User not found" });
                } else {
                    // get the room id from the given user
                    let room_id = await this.#user_persistence.get_room_id(user_id);
                    // get the total number of users in the room
                    let users = await this.#room_persistence.get_room_users(room_id);
                    let total_users = users.size;
                    // the room only have 1 user
                    if (total_users === 1) {
                        response.status(200).json({ message: "You have no roommate" });
                        // more than 1 user in the room
                    } else {
                        response.status(200).json({ message: "You have at least one roommate" });
                    }
                }
            }
        } catch (error) {
            response.status(500).json({ message: error.message });
        }
    }
}

module.exports = UserInfoHandler;
