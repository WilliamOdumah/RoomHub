/**
 * @namespace Transaction
 * @description Routes related to transactions
 */
const express = require("express");
const router = express.Router();
const TransactionHandler = require("../Handler/TransactionHandler");

const transaction_handler = new TransactionHandler();

/**
 * @memberof Notification
 * @name Create some new announcement notifications
 * @path {POST} notification/send-announcement
 * @body {String} from The sender user ID
 * @body {String} message The message of announcement
 * @body {String} type The type of notification: must be announcement
 * @code {200} Notify you are the only person in this room
 * @code {200} Announcement Successfully sent
 * @code {404} Error Sending Announcement - User not found
 * @code {400} Error Sending Announcement - Message is empty
 * @code {500} Backend error from the database
 * @response {String} message See description of the different status codes
 */
router.post("/create-expense", (req, res) => {
    transaction_handler.create_Expense(req, res);
});

/**
 * @memberof Transaction
 * @name Get an user amount summary
 * @path {GET} transaction/get-summary?id=userid
 * @query {String} id User requesting to get the summary
 * @code {200} Successfully retrieved amount summary
 * @code {422} Invalid User
 * @code {404} User not found
 * @code {500} Error message from backend
 * @response {JSON} summary amount own and areOwn amount
 * @example Response:
 * {
 * "Own": 5.333333333333332,
 * "Are_owned": 24.666666666666664
 * }
 */
router.get("/get-summary", (req, res) => {
    transaction_handler.get_summary(req, res);
});

/**
 * @memberof Transaction
 * @name Get all transaction details in the room of specific user
 * @path {GET} transaction/get-transaction?id=userid
 * @query {String} id User requesting to get the summary
 * @code {200} Successfully retrieved all transaction details
 * @code {422} Invalid User
 * @code {404} User not found
 * @code {500} Error message from backend
 * @response {JSON} transaction details
 * @example Response: 
 * {
    "All_Transactions": [
        {
            "transaction_date": "202-23",
            "transaction_amount": 10,
            "transaction_name": "Toilet Cleaner"
        },
        {
            "transaction_date": "2024-11-10",
            "transaction_amount": 13,
            "transaction_name": "Dish soap"
        },
        {
            "transaction_date": "2024-11-23",
            "transaction_amount": 16,
            "transaction_name": "Toilet Brush"
        },
        {
            "transaction_date": "2024-11-24",
            "transaction_amount": 10,
            "transaction_name": "dan@gmail.com made a payement to daohl@myumanitoba.ca"
        },
        {
            "transaction_date": "2024-11-30",
            "transaction_amount": 4,
            "transaction_name": "dan@gmail.com made a payement to dan@gmail.com"
        },
        {
            "transaction_date": "2024-11-30",
            "transaction_amount": 4,
            "transaction_name": "dan@gmail.com made a payement to daohl@myumanitoba.ca"
        },
        {
            "transaction_date": "2024-11-23",
            "transaction_amount": 10,
            "transaction_name": "Toilet Cleaner"
        },
        {
            "transaction_date": "2024-11-10",
            "transaction_amount": 30,
            "transaction_name": "Dish soap"
        },
        {
            "transaction_date": "2024-11-20",
            "transaction_amount": 16,
            "transaction_name": "Trash bags"
        }
    ]
}
 */
router.get("/get-transaction", (req, res) => {
    transaction_handler.get_transaction(req, res);
});

router.post("/settle-up", (req, res) => {
    transaction_handler.settle_debt(req, res);
});

router.use("/", (req, res) => {
    res.status(200).json({ message: "Welcome to the Transaction paths" });
});

module.exports = router;
