require("dotenv").config(); // Load environment variables
const NotificationPersistence = require("../../src/Persistence/NotificationPersistence");
const { populate_db } = require("./DbSetup");

describe("NotificationPersistence Class-- Getting message and type", () => {
    let notif_persistence;
    let notif_id;
    let no_msg_notif_id;

    beforeAll(async () => {
        // initialize the notifHandlerobject
        notif_persistence = new NotificationPersistence();
        notif_id = "123";
        no_msg_notif_id = "456";
        await populate_db();
    });

    it("Should retrieve a message, type, notification_id and from", async () => {
        result = await notif_persistence.get_msg_type(notif_id);
        expect(result).toStrictEqual({
            from: "test@gmail.com",
            msg: "abc invite bcd",
            type: "invite",
            notification_id: "123",
        });
    });

    it("Should throw an error because the notification doesn't have a message", async () => {
        await expect(notif_persistence.get_msg_type(no_msg_notif_id)).rejects.toThrow(
            "Notification doesn't have a message",
        );
    });
});

describe("NotificationPersistence Class -- Creating a new notification", () => {
    let notif_persistence;
    let notif_id;
    let no_msg_notif_id;

    beforeAll(async () => {
        // initialize the notifHandlerobject
        notif_persistence = new NotificationPersistence();
        notif_id = "123";
        no_msg_notif_id = "456";
        await populate_db();
    });

    it("Should return SUCCESS- signifying the notification is successfully created ", async () => {
        result = await notif_persistence.generate_new_notification(
            "1045",
            "hello world",
            "test@gmail.com",
            "test2@gmail.com",
            "invite",
            "rm_11",
        );
        expect(result).toBe("SUCCESS");
    });

    it("Should return FAILED- signifying the notification is was not successfully created ", async () => {
        result = await notif_persistence.generate_new_notification(
            "1045",
            "hello world",
            "test@gmail.com",
            "test2@gmail.com",
            "invite",
            "rm_11",
        );
        expect(result).toBe("FAILED");
    });
});

describe("NotificationPersistence Class -- Update a notification state", () => {
    let notif_persistence;
    let notif_id;
    let no_msg_notif_id;

    beforeAll(async () => {
        // initialize the notifHandlerobject
        notif_persistence = new NotificationPersistence();
        notif_id = "123";
        no_msg_notif_id = "456";
        await populate_db();
    });

    it("Should not throw errror - meaning successful update of the state", async () => {
        await expect(notif_persistence.update_notification_status(notif_id)).resolves.not.toThrow();
    });
});

describe("NotificationPersistence Class-- Delete a notification", () => {
    let notif_persistence;
    let notif_id;
    let user_id;

    beforeAll(async () => {
        // initialize the notifHandlerobject
        notif_persistence = new NotificationPersistence();
        notif_id = "delete_req";
        await populate_db();
    });
    it("Should not throw error- Meaning successful deletion of the notification", async () => {
        await expect(notif_persistence.delete_notification(notif_id)).resolves.not.toThrow();
    });
});
