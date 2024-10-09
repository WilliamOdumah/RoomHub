const RoomHandler = require("../../../src/Handler/RoomHandler");
const { mockRequest, mockResponse } = require("mock-req-res");

jest.mock("../../../src/Utility/Services", () => ({
    get_user_persistence: () => ({
        get_user: jest.fn(),
        update_user_room: jest.fn(),
        update_notification_set: jest.fn(),
    }),

    get_room_persistence: () => ({
        get_room_name: jest.fn(),
        generate_new_room: jest.fn(),
        add_new_roommate: jest.fn(),
    }),

    get_notification_persistence: () => ({
        get_msg_type: jest.fn(),
        delete_notification: jest.fn(),
    }),
}));

describe("Unit test for creating room", () => {
    let roomHandler;
    let req, res;

    beforeEach(() => {
        roomHandler = new RoomHandler();
        req = mockRequest();
        res = mockResponse();

        res.status = jest.fn().mockReturnValue(res); // Allows chaining like res.status(200).json()
        res.json = jest.fn();
        jest.clearAllMocks();
    });

    it("Send a success response verifying that the room was correctly created", async () => {
        // mock get_user and get_room_name
        roomHandler.get_user_persistence().get_user.mockImplementation(() => {
            return { user_id: "test@gmail.com", room_id: "111-111" };
        });
        roomHandler.get_room_persistence().generate_new_room.mockImplementation((room_id, room_name, user_id) => {
            return "SUCCESS";
        });

        req.body = { id: "test@gmail.com", rm: "1000" };

        await roomHandler.create_room(req, res);

        expect(res.status).toHaveBeenCalledWith(200);
        expect(res.json).toHaveBeenCalledWith({ message: "Successfully Created the new room" });
    });

    it("Send a response signifying that the room was not created", async () => {
        // mock get_user and get_room_name
        roomHandler.get_user_persistence().get_user.mockImplementation(() => {
            return { user_id: "test@gmail.com", room_id: "111-111" };
        });
        roomHandler.get_room_persistence().generate_new_room.mockImplementation((room_id, room_name, user_id) => {
            return "FAILURE";
        });

        req.body = { id: "test@gmail.com", rm: "1000" };

        await roomHandler.create_room(req, res);

        expect(res.status).toHaveBeenCalledWith(500);
        expect(res.json).toHaveBeenCalledWith({ message: "Retry creating the room" });
    });

    it("Send a response signifying that the user name is invalid", async () => {
        // mock get_user and get_room_name
        roomHandler.get_user_persistence().get_user.mockImplementation(() => {
            return null;
        });

        req.body = { id: "test@gmail.com", rm: "1000" };

        await roomHandler.create_room(req, res);

        expect(res.status).toHaveBeenCalledWith(400);
        expect(res.json).toHaveBeenCalledWith({ message: "Bad Request-Invalid User" });
    });

    it("Send a response signifying that the room name is invalid", async () => {
        // mock get_user and get_room_name
        roomHandler.get_user_persistence().get_user.mockImplementation(() => {
            return { user_id: "test@gmail.com", room_id: "111-111" };
        });

        req.body = { id: "test@gmail.com", rm: "" };

        await roomHandler.create_room(req, res);

        expect(res.status).toHaveBeenCalledWith(400);
        expect(res.json).toHaveBeenCalledWith({ message: "Bad Request-Invalid Room Name" });
    });

    it("Send a response signifying that the room name and user name are invalid", async () => {
        // mock get_user and get_room_name
        roomHandler.get_user_persistence().get_user.mockImplementation(() => {
            return null;
        });

        req.body = { id: "test@gmail.com", rm: "" };

        await roomHandler.create_room(req, res);

        expect(res.status).toHaveBeenCalledWith(400);
        expect(res.json).toHaveBeenCalledWith({ message: "Bad Request-Invalid User and room name" });
    });

    it("Send a response signifying that some other error has been thrown from database", async () => {
        // mock get_user and get_room_name
        roomHandler.get_user_persistence().get_user.mockImplementation(() => {
            throw new Error("Sample db error");
        });

        req.body = { id: "test@gmail.com", rm: "" };

        await roomHandler.create_room(req, res);

        expect(res.status).toHaveBeenCalledWith(500);
        expect(res.json).toHaveBeenCalledWith(expect.any(Object));
    });
});

describe("Unit test for adding roommate", () => {
    let roomHandler;
    let req, res;

    beforeEach(() => {
        roomHandler = new RoomHandler();
        req = mockRequest();
        res = mockResponse();

        res.status = jest.fn().mockReturnValue(res); // Allows chaining like res.status(200).json()
        res.json = jest.fn();
        jest.clearAllMocks();
    });

    it("Send a success response verifying that the new roomate was successfully added to the room", async () => {
        // mock all required persistence
        roomHandler.get_user_persistence().get_user.mockImplementation((user_id) => {
            if (user_id === "test1@gmail.com") {
                return { user_id: "test1@gmail.com", room_id: "111-111" };
            } else {
                return { user_id: "test2@gmail.com", room_id: "111-111" };
            }
        });
        roomHandler.get_room_persistence().generate_new_room.mockImplementation((room_id, room_name, user_id) => {
            return "SUCCESS";
        });

        roomHandler.get_room_persistence().get_room_name.mockImplementation((room_id) => {
            return "Test_rm";
        });

        req.body = {
            existing_roommate: "test1@gmail.com",
            new_roommate: "test2@gmail.com",
            room_nm: "test_rm",
            notification_id: "111",
        };

        await roomHandler.add_roommate(req, res);

        expect(res.status).toHaveBeenCalledWith(200);
        expect(res.json).toHaveBeenCalledWith({ message: "New Roommate successfully added" });
    });

    it('Send a response signifying that the "existing " roommate doesn\'t live in that room anymore', async () => {
        // mock all required persistence
        roomHandler.get_user_persistence().get_user.mockImplementation((user_id) => {
            if (user_id === "test1@gmail.com") {
                return { user_id: "test1@gmail.com", room_id: "111-111" };
            } else {
                return { user_id: "test2@gmail.com", room_id: "111-111" };
            }
        });

        roomHandler.get_room_persistence().get_room_name.mockImplementation((room_id) => {
            return "different_room";
        });

        req.body = {
            existing_roommate: "test1@gmail.com",
            new_roommate: "test2@gmail.com",
            room_nm: "test_rm",
            notification_id: "111",
        };

        await roomHandler.add_roommate(req, res);

        expect(res.status).toHaveBeenCalledWith(404);
        expect(res.json).toHaveBeenCalledWith({ message: "Room not found" });
    });

    it("Send a response signifying that the old roommate doesn't belong to a room", async () => {
        // mock all required persistence
        roomHandler.get_user_persistence().get_user.mockImplementation((user_id) => {
            if (user_id === "test1@gmail.com") {
                return { user_id: "test1@gmail.com" };
            } else {
                return { user_id: "test2@gmail.com", room_id: "111-111" };
            }
        });

        req.body = {
            existing_roommate: "test1@gmail.com",
            new_roommate: "test2@gmail.com",
            room_nm: "test_rm",
            notification_id: "111",
        };

        await roomHandler.add_roommate(req, res);

        expect(res.status).toHaveBeenCalledWith(404);
        expect(res.json).toHaveBeenCalledWith({ message: "Room not found. Create or Join a room" });
    });

    it("Send a response verifying that both users don't exist", async () => {
        // mock all required persistence
        roomHandler.get_user_persistence().get_user.mockImplementation((user_id) => {
            return null;
        });

        req.body = {
            existing_roommate: "test1@gmail.com",
            new_roommate: "test2@gmail.com",
            room_nm: "test_rm",
            notification_id: "111",
        };

        await roomHandler.add_roommate(req, res);

        expect(res.status).toHaveBeenCalledWith(404);
        expect(res.json).toHaveBeenCalledWith({ message: "Users not found" });
    });

    it("Send a response verifying that new roommate doesn't exist", async () => {
        // mock all required persistence
        roomHandler.get_user_persistence().get_user.mockImplementation((user_id) => {
            if (user_id === "test1@gmail.com") {
                return { user_id: "test1@gmail.com" };
            } else {
                return null;
            }
        });

        req.body = {
            existing_roommate: "test1@gmail.com",
            new_roommate: "test2@gmail.com",
            room_nm: "test_rm",
            notification_id: "111",
        };

        await roomHandler.add_roommate(req, res);

        expect(res.status).toHaveBeenCalledWith(404);
        expect(res.json).toHaveBeenCalledWith({ message: "New roommate not found" });
    });

    it("Send a response verifying that new roommate doesn't exist", async () => {
        // mock all required persistence
        roomHandler.get_user_persistence().get_user.mockImplementation((user_id) => {
            if (user_id === "test1@gmail.com") {
                return null;
            } else {
                return { user_id: "test2@gmail.com", room_id: "111-111" };
            }
        });

        req.body = {
            existing_roommate: "test1@gmail.com",
            new_roommate: "test2@gmail.com",
            room_nm: "test_rm",
            notification_id: "111",
        };

        await roomHandler.add_roommate(req, res);

        expect(res.status).toHaveBeenCalledWith(404);
        expect(res.json).toHaveBeenCalledWith({ message: "User in room not found" });
    });

    it("Send a response verifying that a server error occured", async () => {
        // mock all required persistence
        roomHandler.get_user_persistence().get_user.mockImplementation((user_id) => {
            throw new Error("Something has occured");
        });

        req.body = {
            existing_roommate: "test1@gmail.com",
            new_roommate: "test2@gmail.com",
            room_nm: "test_rm",
            notification_id: "111",
        };

        await roomHandler.add_roommate(req, res);

        expect(res.status).toHaveBeenCalledWith(500);
        expect(res.json).toHaveBeenCalledWith(expect.any(Object));
    });
});
