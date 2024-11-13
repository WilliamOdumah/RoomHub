/**
 * Validate a value is a valid stringr. If not throw an error
 * @param {int} name "The value to be validated"
 * @param {String} type "The type that the string represents"
 */
function validateString(name, type) {
    if (!name || typeof name !== "string" || name.length < 1) {
        throw new Error(`Invalid ${type}`);
    }
}

/**
 * Validate a value is positive integer. If not throw an error
 * @param {int} value "The value to be validated"
 * @param {String} type "The type that the value represents"
 */
function validatePositiveInteger(value, type) {
    if (typeof value !== "number" || value <= 0) throw new Error(`Invalid ${type}- ${type} must be a positive number`);
}

/**
 * Validate a list is non empty if empty throw error
 * @param {list} input_list "Input list of string"
 * @param {String} type "The type of the list- useful for error message"
 */
function validateNonEmptyList(input_list, type) {
    if (!Array.isArray(input_list) || input_list.length <= 0)
        throw new Error(`Invalid ${type}- ${type} must be a non empty list`);
}

/**
 * Validate a date string.
 * @param {String} dateString "The date string to be validated in yyyy-MM-dd format"
 * @returns {Boolean} "True if valid date format and date is today or in the future, false otherwise"
 */
function validateDate(date) {
    // Regular expression to validate the format (yyyy-MM-dd)
    const dateRegExp = /^\d{4}-\d{2}-\d{2}$/;
    // Check if the date string matches the yyyy-MM-dd format
    if (!dateRegExp.test(date)) {
        throw new Error(`Invalid Date`);
    }
    // Parse the date string to a JavaScript Date object
    const inputDate = new Date(date);

    // Check if the parsed date is valid
    if (isNaN(inputDate.getTime())) {
        throw new Error(`Invalid Date`);
    }
    // Get today's date in yyyy-MM-dd format (ignore time part)
    const today = new Date();
    today.setHours(0, 0, 0, 0); // Set the time to 00:00:00 to only compare dates
    // Compare the input date with today's date
    if (inputDate > today) throw new Error(`Invalid Date`); // Returns false if inputDate is in the past
}

/**
 * Throw an error if user does not exist.
 * @param {Object} user_persistence "User persistence object"
 * @param {String} userId "User id to be validated"
 */
async function validateUserExist(user_persistence, userId) {
    let user = await user_persistence.get_user(userId);
    if (user === null) {
        throw new Error("User does not exist");
    }
}

/**
 * Throw error if user2 isn't a member of user1's room
 * @param {Object} room_persistence "Room persistence object"
 * @param {String} user2 "String representing the second user"
 * @param {String} user1_room_id "String representing the users room"
 */
async function validateUsersAreRoommates(room_persistence, user2, user1_room_id) {
    let users_set = await room_persistence.get_room_users(user1_room_id);
    const users = Array.from(users_set);
    if (!users.map((str) => str.toLowerCase()).includes(user2.toLowerCase())) {
        throw new Error("Users are not roommates");
    }
}

/**
 * Throw error if a users in contributors don't belong to the payers room
 * @param {Object} room_persistence "Room persistence object"
 * @param {list} contributors "A list of userid's"
 * @param {String} payer "A user id"
 * @param {String} room_id "String representing the users room id"
 */
async function validateContributorsAreRoommates(room_persistence, contributors, payer, room_id) {
    // Get the users in the room
    const users_set = await room_persistence.get_room_users(room_id);
    const users = Array.from(users_set).map((user) => user.toLowerCase());

    // Prepare the list of contributors including the payer
    const contributorsWithPayer = [
        ...contributors.map((contributor) => contributor.toLowerCase()),
        payer.toLowerCase(),
    ];

    // Check if every contributor and the payer exist in the users set
    const invalidContributors = contributorsWithPayer.filter((contributor) => !users.includes(contributor));
    if (invalidContributors.length > 0) {
        throw new Error(`One or more contributors do not belong to this room: ${invalidContributors.join(", ")}`);
    }
}

/**
 * Throw error if the outstanding balance is invalid.
 * @param {Object} transaction_persistence "Transaction persistence object"
 * @param {String} creditor "Creditors user Id"
 * @param {String} debtor "debtors user id"
 * @param {int} settle_up_amnt "The amount to be settled"
 */
async function validateOutstandingBalance(transaction_persistence, creditor, debtor, settle_up_amnt) {
    const result = await transaction_persistence.getBalanceRecord(debtor, creditor);
    if (result != null) {
        const currOutstanding = result.amount;
        if (currOutstanding < settle_up_amnt) {
            throw new Error("Settle up amount must be less than or equal to outstanding balance");
        }
    } else {
        throw new Error("No outstanding balance to be settled");
    }
}

module.exports = {
    validateString,
    validatePositiveInteger,
    validateDate,
    validateUserExist,
    validateContributorsAreRoommates,
    validateOutstandingBalance,
    validateUsersAreRoommates,
    validateNonEmptyList,
};
