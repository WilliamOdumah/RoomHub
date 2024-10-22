require("dotenv").config(); // Load environment variables
const RoomPersistence = require("../../src/Persistence/RoomPersistence");
const { populate_db } = require("./DbSetup");

describe("RoomPersistence Class-- Getting a room name", () => {
    let room_persistence;
    let room_id;
    let no_name_room_id;

    beforeAll(async () => {
        // initialize the userHandlerobject
        room_persistence = new RoomPersistence();
        room_id = "rm_11";
        no_name_room_id = "rm_bad";
        await populate_db();
    });

    it("Should retrieve a valid room name", async () => {
        result = await room_persistence.get_room_name(room_id);
        expect(result).toBe("test_room1");
    });

    it("Should throw an error because the room doesn't have a name--(This case should be impossible)", async () => {
        await expect(room_persistence.get_room_name(no_name_room_id)).rejects.toThrow(
            "Room doesn't have a name--Service Unavailable",
        );
    });
});

describe("UserPersistence Class-- Creating a new room", () => {
    let room_persistence;
    let room_id;
    let no_name_room_id;

    beforeAll(async () => {
        // initialize the userHandlerobject
        room_persistence = new RoomPersistence();
        room_id = "rm_11";
        no_name_room_id = "rm_bad";
        await populate_db();
    });

    it("Should return SUCCESS- signifying the room is successfully created ", async () => {
        result = await room_persistence.generate_new_room("rm_12", "test_room2", "test2@gmail.com");
        expect(result).toBe("SUCCESS");
    });

    it("Should return FAILED- signifying the room is was not successfully created ", async () => {
        result = await room_persistence.generate_new_room("rm_12", "test_room2", "test2@gmail.com");
        expect(result).toBe("FAILED");
    });
});

describe("UserPersistence Class-- Adding a new roommmate", () => {
    let room_persistence;

    beforeAll(async () => {
        // initialize the userHandlerobject
        room_persistence = new RoomPersistence();
        await populate_db();
    });

    it("Should not throw an error- Signifies successful list of roomates update ", async () => {
        await expect(room_persistence.add_new_roommate("rm_11", "test11@gmail.com")).resolves.not.toThrow();
    });

    // check what update command does.
    // it("Should throw an error- Signifies an error from the backend", async () => {
    //     await expect(room_persistence.add_new_roommate("rm_notexist", "test11@gmail.com")).rejects.toThrow();
    // });
});
