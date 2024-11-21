/**
 * All services to access the different persistence objects
 * @module Services
 */

// userpersistence object-- to get access to all the methods
const UserPersistence = require("../Persistence/UserPersistence");
const RoomPersistence = require("../Persistence/RoomPersistence");
const NotificationPersistence = require("../Persistence/NotificationPersistence");
const TaskPersistence = require("../Persistence/TaskPersistence");
const ProfilePersistence = require("../Persistence/ProfilePersistence");
const ReviewPersistence = require("../Persistence/ReviewPersistence");
const TransactionPersistence = require("../Persistence/TransactionPersistence");

/**
 * Services to make sure only one instance of different persistence exist.
 * @class
 */
class Services {
    // only one instance of the all persistence is created
    static #user_persistence = null;
    static #room_persistence = null;
    static #notification_persistence = null;
    static #task_persistence = null;
    static #profile_persistence = null;
    static #review_persistence = null;
    static #transaction_persistence = null;

    static get_user_persistence() {
        if (this.#user_persistence === null) {
            this.#user_persistence = new UserPersistence();
        }

        return this.#user_persistence;
    }

    static get_room_persistence() {
        if (this.#room_persistence === null) {
            this.#room_persistence = new RoomPersistence();
        }

        return this.#room_persistence;
    }

    static get_notification_persistence() {
        if (this.#notification_persistence === null) {
            this.#notification_persistence = new NotificationPersistence();
        }

        return this.#notification_persistence;
    }

    static get_task_persistence() {
        if (this.#task_persistence === null) {
            this.#task_persistence = new TaskPersistence();
        }
        return this.#task_persistence;
    }

    static get_profile_persistence() {
        if (this.#profile_persistence === null) {
            this.#profile_persistence = new ProfilePersistence();
        }
        return this.#profile_persistence;
    }

    static get_review_persistence() {
        if (this.#review_persistence === null) {
            this.#review_persistence = new ReviewPersistence();
        }
        return this.#review_persistence;
    }
    static get_transaction_persistence() {
        if (this.#transaction_persistence === null) {
            this.#transaction_persistence = new TransactionPersistence();
        }

        return this.#transaction_persistence;
    }
}

module.exports = Services;
