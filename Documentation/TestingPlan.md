# Testing Plan RoomHub - Sprint1

## 1. Scope

The testplan for this sprint contains Unit tests and Integration tests 

## 2. Test Methodology

### 2.1 Test Levels
- **Unit Testing**: Test individual components or functions for correctness.
- **Integration Testing**: Test that database queries are correctly interpreted and the correct values are retrieved.

### 2.2 Unit Tests
   - Unit Tests are split into Router unit tests and Handler Unit tests

##### 2.21 Router Unit Tests
**NB** : For this set of tests handlers are mocked
1. Index Route- Base paths
   1. Get /user/ should return welcome to the api paths
   2. Get /room/ should Should return welcome to the room paths
   3. Post /user/add-user Should return welcome to the notification paths
   
2. User Route
   1. Get /user/:id/get-room should call the UserInfoHandler
   2. Get /user/:id/get-notification should UserInfoHandler 
   3. Post /user/add-user should call the UserInfoHandler

3. Room Route
   1. Post room/create-room should call the create_room function in room_handler
   2. Post room/add-roommate should call the add_roommate method in the room_handler 

4. Notification Route
   1. Post notification/create-notification should call the create_notification function in NotificationHandler

##### 2.22 Handler Unit Tests
**NB** : For the Handler unit tests the persistence is mocked.

1. UserInfoHandler
    **Fetching User's Room (.create_user)**
    1. Test Case: Successful User Creation
        - Input: Valid user data (e.g., { id: "abc@gmail.com" }).
        - Expected Output: 200 OK with { message: "User created successfully" }.
        - Mock: Mock save_new_user to return success.

    2. Test Case: Invalid User ID-- User creation
        - Input: Invalid or empty user ID (e.g., { id: "" }).
        - Expected Output: 400 Bad Request with { message: "Error Creating User- User id is invalid" }.

    3. Test Case: Internal Server Error-- User creation
        - Input: Valid user data (e.g., { id: "bcd@gmail.com" }).
        - Mock: Mock save_new_user to throw an exception.
        - Expected Output: 500 Internal Server Error with { - message: "Something went wrong" }. 
    **Fetching User's Room (.get_user_room)**
    4.  Test Case: Successfully Retrieve Room Name
        - Input: Valid user ID (e.g., test@gmail.com).
        - Mock: Mock get_user to return a user with a valid - room_id, and get_room_name to return the room name.
        - Expected Output: 200 OK with { room_name: "UpBoyz" }.
    5. Test Case: Invalid User ID
        - Input: Invalid or empty user ID.
        - Expected Output: 400 Bad Request with { room_name: "This username is invalid" }.
    6. Test Case: User Not Found
         - Input: Non-existent user (e.g., fake_user@gmail.com).
         - Mock: Mock get_user to return null.
         - Expected Output: 404 Not Found with { room_name: "User not found" }.
    7. Test Case: No Room Assigned
        - Input: User with no room assigned.
        - Mock: Mock get_user to return a user without room_id, and get_room_name to return undefined.
        - Expected Output: 200 OK with { room_name: "NA" }.
    8. Test Case : Internal Server Error
        - Input: Valid user ID but the backend throws an exception.
        - Expected Output: 500 Internal Server Error with generic error object.
    **Fetching User's Notifications (.get_user_notification)**
    9. Test Case: Successfully Fetch Notifications
        - Input: Valid user ID (e.g., test@gmail.com).
        - Mock:
        - Mock get_user to return a valid user.
        - Mock get_notification to return a list of notification IDs.
        - Mock get_msg_type to return a notification message and type for each notification ID.
        - Expected Output: 200 OK with an array of notifications.
    10.  Test Case: Invalid User ID
        - Input: Invalid or empty user ID.
        - Expected Output: 400 Bad Request with { message: "This username is invalid" }.
    11. Test Case: User Not Found
        - Input: Non-existent user (e.g., fake_user@gmail.com).
        - Mock: Mock get_user to return null.
        - Expected Output: 404 Not Found with { message: "User not found" }.
    12. Test Case: Internal Server Error
        - Input: Valid user ID but backend throws an exception.
        - Expected Output: 500 Internal Server Error with a generic error object.

2. RoomHandler 
**Creating Room (.create_room)**
   1. Test Case: Successfully Create Room
        - Input: Valid user and room data (e.g., { id: "test@gmail.com", rm: "1000" }).
        - Mock:
        - get_user returns { user_id: "test@gmail.com", room_id: "111-111" }.
        - generate_new_room returns "SUCCESS".
        - Expected Output: 200 OK with { message: "Successfully Created the new room" }. 
    2. Test Case: Failed Room Creation
        - Input: Valid user and room data (e.g., { id: "test@gmail.com", rm: "1000" }).
        - Mock:
        - get_user returns { user_id: "test@gmail.com", room_id: "111-111" }.
        - generate_new_room returns "FAILURE".
        - Expected Output: 500 Internal Server Error with { message: "Retry creating the room" }.
    3. Test Case: Invalid User

        - Input: Invalid or nonexistent user (e.g., { id: "test@gmail.com", rm: "1000" }).
        - Mock:
        - get_user returns null.
        - Expected Output: 400 Bad Request with { message: "Bad Request-Invalid User" }.
    4. Test Case: Invalid Room Name
        - Input: Valid user, empty room name (e.g., { id: "test@gmail.com", rm: "" }).
        - Mock:
        - get_user returns { user_id: "test@gmail.com", room_id: "111-111" }.
        - Expected Output: 400 Bad Request with { message: "Bad Request-Invalid Room Name" }.
    5. Test Case: Invalid User and Room Name
        - Input: Invalid user and empty room name (e.g., { id: "test@gmail.com", rm: "" }).
        - Mock:
        - get_user returns null.
        - Expected Output: 400 Bad Request with { message: "Bad Request-Invalid User and room name" }.
    6. Test Case: Database Error
        - Input: Valid user and room data (e.g., { id: "test@gmail.com", rm: "" }).
        - Mock:
        - get_user throws an exception (Error("Sample db error")).
        - Expected Output: 500 Internal Server Error with error object.
**Adding Roommate (.add_roommate)**
    7. Test Case: Successfully Add Roommate
        - Input: Valid existing and new roommate data (e.g., { existing_roommate: "test1@gmail.com", new_roommate: "test2@gmail.com", room_nm: "test_rm", notification_id: "111" }).
        - Mock:
        - get_user("test1@gmail.com") returns { user_id: "test1@gmail.com", room_id: "111-111" }.
        - get_user("test2@gmail.com") returns { user_id: "test2@gmail.com", room_id: "111-111" }.
        - get_room_name("111-111") returns "Test_rm".
        - Expected Output: 200 OK with { message: "New Roommate successfully added" }.
    8.  Test Case: Existing Roommate Not in Room
        - Input: Valid existing and new roommate data, but the existing roommate is not in the room (e.g., { existing_roommate: "test1@gmail.com", new_roommate: "test2@gmail.com", room_nm: "test_rm", notification_id: "111" }).
        - Mock:
        - get_user("test1@gmail.com") returns { user_id: "test1@gmail.com", room_id: "111-111" }.
        - get_room_name("111-111") returns "different_room".
        - Expected Output: 404 Not Found with { message: "Room not found" }.
   9. Test Case: Existing Roommate Without a Room
        - Input: Existing roommate has no room (e.g., { existing_roommate: "test1@gmail.com", new_roommate: "test2@gmail.com", room_nm: "test_rm", notification_id: "111" }).
        - Mock:
        - get_user("test1@gmail.com") returns { user_id: "test1@gmail.com" } (no room_id).
        - Expected Output: 404 Not Found with { message: "Room not found. Create or Join a room" }.
   10. Test Case: Both Roommates Not Found
        - Input: Nonexistent users (e.g., { existing_roommate: "test1@gmail.com", new_roommate: "test2@gmail.com", room_nm: "test_rm", notification_id: "111" }).
        - Mock:
        - get_user returns null for both.
        - Expected Output: 404 Not Found with { message: "Users not found" }.
   11. Test Case: New Roommate Not Found
        - Input: Existing roommate found, but new roommate does not exist (e.g., { existing_roommate: "test1@gmail.com", new_roommate: "test2@gmail.com", room_nm: "test_rm", notification_id: "111" }).
        - Mock:
        - get_user("test1@gmail.com") returns { user_id: "test1@gmail.com" }.
        - get_user("test2@gmail.com") returns null.
        - Expected Output: 404 Not Found with { message: "New roommate not found" }.
   12. Test Case: Server Error
        - Input: Any data (e.g., { existing_roommate: "test1@gmail.com", new_roommate: "test2@gmail.com", room_nm: "test_rm", notification_id: "111" }).
        - Mock:
        - get_user throws an error (Error("Something has occured")).
        - Expected Output: 500 Internal Server Error with error object.
        
3. Notification Handler
**Creating Notifications (.create_notification)**  
    1. Test Case: Send a success response verifying that the notification was correctly created

        - Input: Request body with { from: "test123@gmail.com", to: "test234@gmail.com", type: "invite" }.
        - Mock:
        - get_user_persistence.get_user returns { user_id: "test123@gmail.com", notification: ["111-111", "222-222"], room_id: "123-123" }.
        - get_user_persistence.get_room_id returns "123-123".
        - generate_new_notification returns "SUCCESS".
        - update_user_notifications logs the correct notification update.
        - Expected Output: 200 OK with { message: "Successfully Created the new notification" }.
    2. Test Case: Send a response signifying that the notification was not created
        - Input: Request body with { from: "test123@gmail.com", to: "test234@gmail.com", type: "invite" }.
        - Mock:
        - get_user_persistence.get_user returns user data for both users.
        - generate_new_notification returns "FAILURE".
        - Expected Output: 500 Internal Server Error with { message: "Retry creating the notification" }.
     
    3. Test Case: Send a response signifying that the sender or receiver does not exist

        - Input: Request body with { from: "test123@gmail.com", to: "test234@gmail.com", type: "invite" }.
        - Mock: get_user_persistence.get_user returns null.
        - Expected Output: 404 Not Found with { message: "User not found" }.
   4. Test Case: Send a response signifying that the message is invalid
        - Input: Request body with { from: "test123@gmail.com", to: "test234@gmail.com", type: "" }.
        - Mock:
        - get_user_persistence.get_user returns valid user data.
        - generate_new_notification returns "SUCCESS".
        - update_user_notifications logs the correct notification update.
        - Expected Output: 400 Bad Request with { message: "Error Creating Notification - Message is empty" }.
    5. Test Case: Send a response verifying that a server error occurred
        - Input: Request body with { from: "test123@gmail.com", to: "test234@gmail.com", type: "invite" }.
        - Mock: get_user_persistence.get_user throws an error.
        - Expected Output: 500 Internal Server Error with an error object.
    6. Test Case: Send an error saying the user not found
        - Input: Request body with { from: "test123@gmail.com", to: "", type: "invite" }.
        - Mock:
        - get_user_persistence.get_user returns valid user data for the sender.
        - generate_new_notification returns "SUCCESS".
        - Expected Output: 404 Not Found with { message: "User not found" }.

##### 2.22 Persistence Integration Tests
1. UserPersistence
   1. Test Case 1: Create a new user
       - Input: user_id = "test3@gmail.com"
       - Expected Output:
       Status 200 with { message: "User Successfully created" }.
   2. Test Case 2: Create an existing user
        - Input: user_id = "test3@gmail.com"
        - Expected Output:
        Status 200 with { message: "This user name already exist" }.
    3. Test Case 3: Retrieve an existing user
        - Input: user_id = "test@gmail.com"
        - Expected Output:
        Retrieved user data: { user_id: "test@gmail.com", notification: new Set(["123", "456", "delete_req"]), room_id: "rm_11" }.
    4. Test Case 4: Retrieve a non-existent user
        - Input: user_id = "testfake@gmail.com"
        - Expected Output:
        Returns null since the user does not exist.
    5. Test Case 5: Update a user's room
        - Input: user_id = "test2@gmail.com", room_id = "rm_11"
        - Expected Output:
        No errors are thrown, indicating a successful update.
    6. Test Case 6: Retrieve an existing user's room ID
        - Input: user_id = "test@gmail.com"
        - Expected Output:
        Returns the room ID: "rm_11".
    7. Test Case 7: Retrieve room ID for a user with no room
        - Input: user_id = "test11@gmail.com"
        - Expected Output:
        Throws an error: "User test11@gmail.com doesn't have a room yet".
    8. Test Case 8: Retrieve an existing user's notifications
        - Input: user_id = "test@gmail.com"
        - Expected Output:
        Returns the notification set: new Set(["123", "456", "delete_req"]).
    9. Test Case 9: Retrieve notifications for a user with no notifications
        - Input: user_id = "test11@gmail.com"
        - Expected Output:
        Returns an empty notification set.
    10. Test Case 10: Update a user's notifications
        - Input: user_id = "test@gmail.com", notif_id = "123"
        - Expected Output:
        No errors are thrown, indicating a successful notification update.
    11. Test Case 11: Delete a notification from a user's set of notifications
        - Input: user_id = "test@gmail.com", notif_id = "123"
        - Expected Output:
        No errors are thrown, indicating successful deletion of the notification.
2. NotificationPersistence
   1. Test Case 1: Retrieve message, type, notification_id, and from database.
        - Input: notif_id = "123"
        Expected Output:
        - Object returned: { from: "test@gmail.com", msg: "abc invite bcd", type: "invite", notification_id: "123" }.
   2. Test Case 2: Error when notification doesn't have a message
        - Input: notif_id = "456"
        - Expected Output:
        Error: "Notification doesn't have a message".
   3. Test Case 3: Successfully create a new notification
        - Expected Output:
        Return value: "SUCCESS".
   4. Test Case 4: Failed to create a new notification
        - Return value: "FAILED".
   5. Test Case 5: Successfully update a notification state
        - Input: notif_id = "123"
        - No errors thrown, indicating successful update.
   6. Test Case 6: Successfully delete a notification
        - No errors thrown, indicating successful deletion. 
3. RoomPersistence
   1. Retrieve a Valid Room Name
        - Description: Fetch the name of a valid room with room_id = "rm_11".
        - Expected Outcome: The method should return the room name "test_room1".
   2. Throw Error if Room Doesn't Have a Name
        - Description: Attempt to fetch a room name using room_id = "rm_bad", which doesn’t have a name.
        - Expected Outcome: The method should throw an error with the message "Room doesn't have a name--Service Unavailable".
    3. Create a New Room Successfully
        - Description: Call generate_new_room() with a unique room ID ("rm_12"), room name ("test_room2"), and a user ID ("test2@gmail.com").
        - Expected Outcome: The method should return "SUCCESS" to signify that the room was created successfully.
    4. Fail to Create a Room with Duplicate Room ID
        - Description: Attempt to create a room with an already existing room ID ("rm_12").
        - Expected Outcome: The method should return "FAILED" due to the ConditionExpression failure.