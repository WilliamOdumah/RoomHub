// Base URL for the API
const url = 'https://7hm4udd9s2.execute-api.ca-central-1.amazonaws.com/dev/';

// Endpoints for user-related API requests
const user = "${url}user"; // Base endpoint for user
const room = "${url}room"; // Base endpoint for room

// GET requests
// Endpoint to get user notifications
// final getNotification = user/:id/get-notification

// Endpoint to get the room associated with a user
// final getusersroom = user/:id/get-room

// POST requests
const joinRoom = "${url}notification/join-room-request"; // Endpoint to send a join room request
const signup = "$user/add-user"; // Endpoint to sign up a new user
const addRoommate =
    "$room/add-roommate"; // Endpoint to add a roommate to an existing room
const createRoom = "$room/create-room"; // Endpoint to create a new room
