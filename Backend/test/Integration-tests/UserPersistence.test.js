require("dotenv").config(); // Load environment variables
const UserInfoHandler = require("../../src/Handler/UserInfoHandler");
const UserPersistence = require("../../src/Persistence/UserPersistence");
const { populate_db } = require("./DbSetup");

describe("UserPersistence Class-- Testing Creating a new user", () => {
    let user_info_handler;
    let user_persistence;
    let user_id;

    beforeAll(async () => {
        // initialize the userHandlerobject
        user_info_handler = new UserInfoHandler();
        user_persistence = new UserPersistence();
        user_id = "test3@gmail.com";
        await populate_db();
    });

    it("Should return values that signify that the user is created", async () => {
        result = await user_persistence.save_new_user(user_id);

        expect(result.status).toBe(200);
        expect(result.message).toBe("User Successfully created");
    });

    it("Should return a response that signifies that the user alraedy exist", async () => {
        result = await user_persistence.save_new_user(user_id);
        expect(result.status).toBe(200);
        expect(result.message).toBe("This user name already exist");
    });
});

describe("UserPersistence Class-- Getting a user", () => {
    let user_persistence;
    let user_id;

    beforeAll(async () => {
        // initialize the userPersistence
        user_persistence = new UserPersistence();

        user_id = "test@gmail.com";
        fake_user_id = "testfake@gmail.com";
        await populate_db();
    });

    it("Should return the retrieved javascript object", async () => {
        result = await user_persistence.get_user(user_id);

        expect(result).toEqual({
            user_id: "test@gmail.com",
            notification: new Set(["123", "456", "delete_req"]),
            room_id: "rm_11",
        });
    });

    it("Should return null- since the user doesn't exist", async () => {
        result = await user_persistence.get_user(fake_user_id);
        expect(result).toEqual(null);
    });
});

describe("UserPersistence Class-- Update a users room", () => {
    let user_persistence;
    let user_id;

    beforeAll(async () => {
        // initialize the userPersistence
        user_persistence = new UserPersistence();

        user_id = "test2@gmail.com";
        room_id = "rm_11";
        await populate_db();
    });

    it("Should not throw error- meaning successful update of the room", async () => {
        await expect(user_persistence.update_user_room(room_id, user_id)).resolves.not.toThrow();
    });
});

describe("UserPresistence Class -- Getting a room id", () => {
    let user_persistence;
    let user_id;
    let no_room_user_id;

    beforeAll(async () => {
        // initialize the userPersistence
        user_persistence = new UserPersistence();

        user_id = "test@gmail.com";
        no_room_user_id = "test11@gmail.com";
        await populate_db();
    });

    it("Should return room id", async () => {
        result = await user_persistence.get_room_id(user_id);
        expect(result).toEqual("rm_11");
    });

    it("Should return an error that user doesn't have a room yet", async () => {
        await expect(user_persistence.get_room_id(no_room_user_id)).rejects.toThrow(
            `User ${no_room_user_id} doesn't have a room yet`,
        );
    });
});

describe("UserPersistence Class -- Getting notifications", () => {
    let user_persistence;
    let user_id;
    let no_notif_user_id;

    beforeAll(async () => {
        // initialize the userPersistence
        user_persistence = new UserPersistence();

        user_id = "test@gmail.com";
        no_notif_user_id = "test11@gmail.com";
        await populate_db();
    });

    it("Should return notification", async () => {
        result = await user_persistence.get_notification(user_id);
        expect(result).toEqual(new Set(["123", "456", "delete_req"]));
    });

    it("Should return an error that user doesn't have a notification yet", async () => {
        let response = await user_persistence.get_notification(no_notif_user_id);
        expect(response).toEqual(new Set([]));
    });
});

describe("UserPersistence Class-- Update a users notification", () => {
    let user_persistence;
    let user_id;
    let notif_id;

    beforeAll(async () => {
        // initialize the userPersistence
        user_persistence = new UserPersistence();

        user_id = "test@gmail.com";
        notif_id = "123";
        await populate_db();
    });
    it("Should not throw error- meaning successful update of the notification", async () => {
        await expect(user_persistence.update_user_notifications(notif_id, user_id)).resolves.not.toThrow();
    });
});

describe("UserPersistence Class-- Deleting a notification from a users set of notifications", () => {
    let user_persistence;
    let user_id;
    let notif_id;

    beforeAll(async () => {
        // initialize the userPersistence
        user_persistence = new UserPersistence();

        user_id = "test@gmail.com";
        notif_id = "123";
        await populate_db();
    });

    it("Should not throw error- meaning successful update of the notification", async () => {
        await expect(user_persistence.update_notification_set(notif_id, user_id)).resolves.not.toThrow();
    });
});
