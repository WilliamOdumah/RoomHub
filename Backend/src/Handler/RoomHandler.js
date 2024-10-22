const Services = require("../Utility/Services");
const { v4: uuidv4 } = require("uuid");

/**
 * @module Handler
 */

/**
 * Represents the Room handler
 * @class
 *
 */
class RoomHandler {
    /**
     * The room persistence object used by the room handler.
     * @type {string}
     * @private
     */
    #room_persistence;
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
    #notification_persistence;

    /**
     * Create a new RoomHandler object
     * @constructor
     */
    constructor() {
        this.#user_persistence = Services.get_user_persistence();
        this.#room_persistence = Services.get_room_persistence();
        this.#notification_persistence = Services.get_notification_persistence();
    }

    get_room_persistence() {
        return this.#room_persistence;
    }

    get_user_persistence() {
        return this.#user_persistence;
    }

    /**
     * Validate a room name
     * @param {String} room_name "The room name to be validated"
     * @returns {Boolean} "True if valid room name and false otherwise"
     */
    #is_valid_room_name(room_name) {
        if (typeof room_name === "string" && room_name.length > 0) {
            return true;
        }
        return false;
    }

    /**
     * Validate a user id
     * @async
     * @param {String} user_id "The user_id to be validated"
     * @returns {Boolean} "True if valid user_id and false otherwise"
     */
    async #is_valid_user(user_id) {
        // call the services to get the user persistence. and ask it to get that user. if it returns something then good if not then bad.
        let user_persistence = this.#user_persistence;
        let user = await user_persistence.get_user(user_id);
        if (user != null) {
            return true;
        }
        return false;
    }

    /**
     * Creates a new room in the persistence layer and updates user
     * @async
     * @param {Express.request} request "Reequest received by the router"
     * @param {Express.response} response "Response to be sent back to the service that sent the original request"
     * @returns {Express.response} "A response object which contains the response to the request."
     */
    async create_room(request, response) {
        try {
            let room_name = request.body.rm.trim().toLowerCase();
            let user_id = request.body.id.trim().toLowerCase();
            const is_valid_room = this.#is_valid_room_name(room_name);
            const is_valid_user = await this.#is_valid_user(user_id);
            if (is_valid_room && is_valid_user) {
                // generate room id
                const room_id = uuidv4();
                let new_room_status = await this.#room_persistence.generate_new_room(room_id, room_name, user_id);
                if (new_room_status === "SUCCESS") {
                    // add the generated room_id to the persons room id
                    // let user_persistence = Services.get_user_persistence();
                    await this.#user_persistence.update_user_room(room_id, user_id);
                    response.status(200).json({ message: "Successfully Created the new room" });
                } else {
                    // throw an error saying try to recreate the room
                    response.status(500).json({ message: "Retry creating the room" });
                }
            } else {
                if (!is_valid_room && is_valid_user) {
                    response.status(400).json({ message: "Bad Request-Invalid Room Name" });
                } else if (is_valid_room && !is_valid_user) {
                    response.status(400).json({ message: "Bad Request-Invalid User" });
                } else {
                    response.status(400).json({ message: "Bad Request-Invalid User and room name" });
                }
            }
        } catch (error) {
            response.status(500).json({ msg: error.message });
        }
    }

    /**
     * Checks if 2 names are the same
     * @param {String} persist_room_name "The room name stored in the persistence layer"
     * @param {String} room_name "The room name passed from the request"
     * @returns {Boolean} "True if both names are the same and false otherwise"
     */
    #is_valid_roomname(persist_room_name, room_name) {
        if (persist_room_name.trim().toLowerCase() === room_name.trim().toLowerCase()) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * Add a new-roommate to an existing roommates room.
     * @param {Express.request} request "Reequest received by the router"
     * @param {Express.response} response "Response to be sent back to the service that sent the original request"
     */
    async add_roommate(request, response) {
        try {
            const existing_roommate_id = request.body.existing_roommate.trim().toLowerCase();
            const new_roommate_id = request.body.new_roommate.trim().toLowerCase();
            const room_name = request.body.room_nm.trim().toLowerCase();
            const notif_id = request.body.notification_id.trim();

            // validate existing roomates room matches with the room_name
            const user_persistence = this.#user_persistence;
            const old_roommate = await user_persistence.get_user(existing_roommate_id);
            const new_roommate = await user_persistence.get_user(new_roommate_id);
            if (old_roommate !== null && new_roommate !== null) {
                const room_id = old_roommate.room_id;
                if (room_id !== undefined) {
                    const db_room_name = await this.#room_persistence.get_room_name(room_id);
                    if (this.#is_valid_roomname(db_room_name, room_name)) {
                        // update the rooms list of users.
                        // update the new_roommates room.
                        await this.#user_persistence.update_user_room(room_id, new_roommate_id);
                        await this.#room_persistence.add_new_roommate(room_id, new_roommate_id);
                        await this.#notification_persistence.delete_notification(notif_id);
                        await this.#user_persistence.update_notification_set(notif_id, existing_roommate_id);
                        response.status(200).json({ message: "New Roommate successfully added" });
                    } else {
                        // basically denying access to that room resource
                        response.status(404).json({ message: "Room not found" });
                    }
                } else {
                    response.status(404).json({ message: "Room not found. Create or Join a room" });
                }
            } else {
                if (new_roommate === null && old_roommate === null) {
                    response.status(404).json({ message: "Users not found" });
                } else if (new_roommate === null && old_roommate !== null) {
                    response.status(404).json({ message: "New roommate not found" });
                } else {
                    response.status(404).json({ message: "User in room not found" });
                }
            }
        } catch (error) {
            response.status(500).json({ message: error.message });
        }
    }
}

module.exports = RoomHandler;
