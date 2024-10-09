const NotificationHandler = require("../../../src/Handler/NotificationHandler");
const { mockRequest, mockResponse } = require("mock-req-res");
const { get_user_persistence, get_notification_persistence } = require("../../../src/Utility/Services");

jest.mock("../../../src/Utility/Services", () => ({
    get_user_persistence: () => ({
        get_user: jest.fn(),
        get_room_id: jest.fn(),
        update_user_notifications: jest.fn(),
    }),

    get_notification_persistence: () => ({
        get_msg_type: jest.fn(),
        generate_new_notification: jest.fn(),
        update_notification_status: jest.fn(),
    }),
}));

describe("Unit test for creating notification", () => {
    let notificationHandler;
    let req, res;
    beforeEach(() => {
        notificationHandler = new NotificationHandler();
        req = mockRequest();
        res = mockResponse();

        res.status = jest.fn().mockReturnValue(res); // Allows chaining like res.status(200).json()
        res.json = jest.fn();
        jest.clearAllMocks();
    });

    it("Send a success response verifying that the notification was correctly created", async () => {
        // mock get_user and get_msg_type
        notificationHandler.get_user_persistence().get_user.mockImplementation(() => {
            return { user_id: "test123@gmail.com", notification: ["111-111", "222-222"], room_id: "123-123" };
        });
        notificationHandler.get_user_persistence().get_room_id.mockImplementation((user_id) => {
            return "123-123";
        });
        notificationHandler.get_user_persistence().get_user.mockImplementation(() => {
            return { user_id: "test234@gmail.com", notification: ["111-111", "222-222"] };
        });
        notificationHandler
            .get_notification_persistence()
            .generate_new_notification.mockImplementation((notif_id, msg, status, from, to, type, room_id) => {
                return "SUCCESS";
            });
        notificationHandler.get_user_persistence().update_user_notifications.mockImplementation((notif_id, user_id) => {
            if (user_id === "test123@gmail.com") {
                console.log(`Update notification ${notif_id} for user ${user_id}`);
            } else if (user_id === "test234@gmail.com") {
                console.log(`Update notification ${notif_id} for user ${user_id}`);
            }
        });

        req.body = { from: "test123@gmail.com", to: "test234@gmail.com", type: "invite" };

        await notificationHandler.create_notification(req, res);

        expect(res.status).toHaveBeenCalledWith(200);
        expect(res.json).toHaveBeenCalledWith({ message: "Successfully Created the new notification" });
    });

    it("Send a response signifying that the notification was not created", async () => {
        // mock get_user and get_room_name
        notificationHandler.get_user_persistence().get_user.mockImplementation(() => {
            return { user_id: "test123@gmail.com", notification: ["111-111", "222-222"], room_id: "123-123" };
        });
        notificationHandler.get_user_persistence().get_room_id.mockImplementation((user_id) => {
            return "123-123";
        });
        notificationHandler.get_user_persistence().get_user.mockImplementation(() => {
            return { user_id: "test234@gmail.com", notification: ["111-111", "222-222"] };
        });
        notificationHandler
            .get_notification_persistence()
            .generate_new_notification.mockImplementation((notif_id, msg, status, from, to, type, room_id) => {
                return "FAILURE";
            });

        req.body = { from: "test123@gmail.com", to: "test234@gmail.com", type: "invite" };

        await notificationHandler.create_notification(req, res);

        expect(res.status).toHaveBeenCalledWith(500);
        expect(res.json).toHaveBeenCalledWith({ message: "Retry creating the notification" });
    });

    it("Send a response signifying that the sender or receiver does not exist", async () => {
        notificationHandler.get_user_persistence().get_user.mockImplementation(() => {
            return null;
        });

        req.body = { from: "test123@gmail.com", to: "test234@gmail.com", type: "invite" };

        await notificationHandler.create_notification(req, res);

        expect(res.status).toHaveBeenCalledWith(404);
        expect(res.json).toHaveBeenCalledWith({ message: "User not found" });
    });

    it("Send a response signifying that the message is invalid", async () => {
        // mock get_user and get_msg_type
        notificationHandler.get_user_persistence().get_user.mockImplementation(() => {
            return { user_id: "test123@gmail.com", notification: ["111-111", "222-222"], room_id: "123-123" };
        });
        notificationHandler.get_user_persistence().get_room_id.mockImplementation((user_id) => {
            return "123-123";
        });
        notificationHandler.get_user_persistence().get_user.mockImplementation(() => {
            return { user_id: "test234@gmail.com", notification: ["111-111", "222-222"] };
        });
        notificationHandler
            .get_notification_persistence()
            .generate_new_notification.mockImplementation((notif_id, msg, status, from, to, type, room_id) => {
                return "SUCCESS";
            });
        notificationHandler.get_user_persistence().update_user_notifications.mockImplementation((notif_id, user_id) => {
            if (user_id === "test123@gmail.com") {
                console.log(`Update notification ${notif_id} for user ${user_id}`);
            } else if (user_id === "test234@gmail.com") {
                console.log(`Update notification ${notif_id} for user ${user_id}`);
            }
        });

        req.body = { from: "test123@gmail.com", to: "test234@gmail.com", type: "" };

        await notificationHandler.create_notification(req, res);

        expect(res.status).toHaveBeenCalledWith(400);
        expect(res.json).toHaveBeenCalledWith({ message: "Error Creating Notification - Message is empty" });
    });

    it("Send a response verifying that a server error occured", async () => {
        // mock all required persistence
        notificationHandler.get_user_persistence().get_user.mockImplementation((user_id) => {
            throw new Error("Something has occured");
        });

        req.body = { from: "test123@gmail.com", to: "test234@gmail.com", type: "invite" };

        await notificationHandler.create_notification(req, res);

        expect(res.status).toHaveBeenCalledWith(500);
        expect(res.json).toHaveBeenCalledWith(expect.any(Object));
    });

    it("Send an error saying the user not found", async () => {
        // mock get_user and get_msg_type
        notificationHandler.get_user_persistence().get_user.mockImplementation(() => {
            return { user_id: "test123@gmail.com", notification: ["111-111", "222-222"], room_id: "123-123" };
        });
        notificationHandler.get_user_persistence().get_room_id.mockImplementation((user_id) => {
            return "123-123";
        });
        notificationHandler.get_user_persistence().get_user.mockImplementation(() => {
            return { user_id: "test234@gmail.com", notification: ["111-111", "222-222"] };
        });
        notificationHandler
            .get_notification_persistence()
            .generate_new_notification.mockImplementation((notif_id, msg, status, from, to, type, room_id) => {
                return "SUCCESS";
            });
        notificationHandler.get_user_persistence().update_user_notifications.mockImplementation((notif_id, user_id) => {
            if (user_id === "test123@gmail.com") {
                console.log(`Update notification ${notif_id} for user ${user_id}`);
            } else if (user_id === "test234@gmail.com") {
                console.log(`Update notification ${notif_id} for user ${user_id}`);
            }
        });

        req.body = { from: "test123@gmail.com", to: "", type: "invite" };

        await notificationHandler.create_notification(req, res);

        expect(res.status).toHaveBeenCalledWith(404);
        expect(res.json).toHaveBeenCalledWith({ message: "User not found" });
    });
});
