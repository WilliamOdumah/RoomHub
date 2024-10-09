const request = require("supertest");
const app = require("../../../src/router/index");

describe("Testing base routes-- Making sure all routes are mounted properly", () => {
    it("Should return welcome to the api paths", async () => {
        const exp_stat = 200;
        const exp_msg = { message: "Welcome to the api" };
        const response = await request(app).get("/");
        expect(response.status).toBe(exp_stat);
        expect(response.body).toEqual(exp_msg);
    });

    it("Should return welcome to the user paths", async () => {
        const exp_stat = 200;
        const exp_msg = { Message: "Welcome to the User paths" };
        const response = await request(app).get("/user");
        expect(response.status).toBe(exp_stat);
        expect(response.body).toEqual(exp_msg);
    });

    it("Should return welcome to the room paths", async () => {
        const exp_stat = 200;
        const exp_msg = { message: "Welcome to the Room paths" };
        const response = await request(app).get("/room");
        expect(response.status).toBe(exp_stat);
        expect(response.body).toEqual(exp_msg);
    });

    it("Should return welcome to the user paths", async () => {
        const exp_stat = 200;
        const exp_msg = { message: "Welcome to the Notification paths" };
        const response = await request(app).get("/notification");
        expect(response.status).toBe(exp_stat);
        expect(response.body).toEqual(exp_msg);
    });
});
