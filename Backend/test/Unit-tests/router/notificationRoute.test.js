const app = require("../../../src/router/index");
const request = require("supertest");

jest.mock("../../../src/Handler/NotificationHandler", () => {
    return jest.fn().mockImplementation(() => ({
        create_notification: jest.fn().mockImplementation((req, res) => {
            res.status(200).json({ message: "Successfully Created the new notification" });
        }),

        send_announcement: jest.fn().mockImplementation((req, res) => {
            res.status(200).json({ message: "Send announcement successfully" });
        }),
    }));
});

describe("Notification router tests", () => {
    beforeEach(() => {
        jest.clearAllMocks();
    });

    it("Post notification/create-notification should call the create_notification function in NotificationHandler", async () => {
        const query_params = {
            from: "test123@gmail.com",
            to: "test234@gmail.com",
            type: "join-request",
        };
        const response = await request(app).post("/notification/join-room-request").send(query_params);
        const exp_stat = 200;
        const exp_msg = { message: "Successfully Created the new notification" };
        expect(response.status).toBe(exp_stat);
        expect(response.body).toEqual(exp_msg);
    });

    it("Post notification/send-announcement should call the send_announcement function in NotificationHandler", async () => {
        const query_params = {
            from: "test123@gmail.com",
            message: "Hello",
            type: "announcement",
        };
        const response = await request(app).post("/notification/send-announcement").send(query_params);
        const exp_stat = 200;
        const exp_msg = { message: "Send announcement successfully" };
        expect(response.status).toBe(exp_stat);
        expect(response.body).toEqual(exp_msg);
    });
});
