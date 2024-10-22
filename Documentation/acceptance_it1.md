
---
# **Acceptance Test for Signing Up to RoomHub**

---

**Project Name:**  RoomHub
**Iteration:**   1
**Test Title:**  Sign in

---

### **1. Purpose**  
To verify that a new user can successfully sign up for an account on RoomHub by entering valid information and confirming their email with a verification code.

---

### **2. Pre-conditions**  
- RoomHub application is installed and running.
- The user is on the sign-up page.

---

### **3. Test Steps**  

| Step Number | Action Description                                    | Input Data                                                | Expected Result                                             |
|-------------|--------------------------------------------------------|-----------------------------------------------------------|-------------------------------------------------------------|
| 1           | Open the RoomHub app and navigate to the sign-up form. | N/A                                                       | Sign-up form is displayed with fields for email, name, and password. |
| 2           | Enter a valid email address in the "Email" field.      | e.g., "testuser@example.com"                               | The email is accepted without error.                         |
| 3           | Enter a full name in the "Full Name" field.            | e.g., "Test User"                                          | The full name is accepted without error.                     |
| 4           | Enter a valid password in the "Password" field.        | e.g., "Password123!"                                       | The password is accepted without error, hidden from view.    |
| 5           | Re-enter the same password in the "Confirm Password" field. | e.g., "Password123!"                                   | The password is accepted without error, hidden from view.    |
| 6           | Click on the "Sign Up" button.                         | N/A                                                       | A new screen should be displayed requesting the verification code. |
| 7           | Enter the verification code received via email.        | e.g., "123456"                                             | The verification code is accepted.                           |
| 8           | Click the "Verify" button.                             | N/A                                                       | The user is successfully registered, and redirected to the dashboard home page. |

---

### **4. Post-conditions**  
- The user is registered in the system and can log in with the email and password provided.
---

### **5. Acceptance Criteria**  
- The user must be able to complete the sign-up process without errors.
- The verification code should be received via email and must be valid.
- Upon entering the verification code, the user should be redirected to the RoomHub home page.

---




# **Acceptance Test for RoomHub Login Functionality**

---

**Project Name:** RoomHub  
**Test Case ID:** ITERATION 1 
**Test Title:** User Login  


---

### **1. Purpose**  
To verify that an existing user can successfully log into RoomHub using their email and password, and that they are redirected appropriately after a successful login.

---

### **2. Pre-conditions**  
- RoomHub application is installed and running.
- The user is using a registered email

---

### **3. Test Steps**  

| Step Number | Action Description                                        | Input Data                               | Expected Result                                                                                  |
|-------------|------------------------------------------------------------|------------------------------------------|--------------------------------------------------------------------------------------------------|
| 1           | Open the RoomHub app and navigate to the login form.       | N/A                                      | The login form is displayed with fields for email and password.                                  |
| 2           | Enter a registered email address in the "Email" field.     | e.g., "aderemid@myumanitoba.ca"                 | The email is accepted without error.                                                             |
| 3           | Enter the correct password for the email in the "Password" field. | e.g., "daniel123"                    | The password is accepted, hidden from view, without error.                                       |
| 4           | Click on the "Log In" button.                              | N/A                                      | User is authenticated, and they are redirected to either the home page for returning users or home page for a new user |
| 5           | If the login is unsuccessful, display an error message.    | N/A                                      | An appropriate error message is shown if the email or password is incorrect, or login fails.      |
| 6           | Log out of the application by clicking the "Log Out" button. | N/A                                    | User is successfully logged out and returned to the login screen.                                |
| 7           | Click on "Don't have an account? Sign Up" to navigate to the sign-up page. | N/A                                 | The user is taken to the sign-up page.                                                           |

---

### **4. Post-conditions**  
- The user is logged into the system and can access the appropriate home page.
- The user can log out of the system.

---

### **5. Acceptance Criteria**  
- The user must be able to log in with a valid email and password.
- Upon login, the user should be redirected to the appropriate page based on their room status.
- The user must be able to log out successfully and return to the login screen.

---


# **Acceptance Test for RoomHub - Create Room Functionality**

---

**Project Name:** RoomHub  
**Test Case ID:** Iteration 1  
**Test Title:** Create Room  


---

### **1. Purpose**  
To verify that a user can successfully create a room in RoomHub, and that the system responds with appropriate feedback and redirection after the room is created.

---

### **2. Pre-conditions**  
- RoomHub application is installed and running.
- The user is logged in and authenticated.

---

### **3. Test Steps**

| Step Number | Action Description                                      | Input Data                    | Expected Result                                                                                  |
|-------------|----------------------------------------------------------|-------------------------------|--------------------------------------------------------------------------------------------------|
| 1           | Open RoomHub app and navigate to the "Create a Room" section. | N/A                           | The "Create a Room" form is displayed.                                                           |
| 2           | Enter a valid room name in the "Name" field.             | e.g., "Room A"                | Room name is accepted and displayed without error.                                                |
| 3           | Click the "Create Room" button.                          | N/A                           | A request is sent to the backend to create the room.                                              |
| 4           | Verify that a success message is displayed if the room creation is successful. | N/A                         | A message like "Room successfully created" is displayed.                                          |
| 5           | After the room is created, check if the user is redirected to a new home page, . | N/A                       | The user is redirected to the "OurHome" page with the newly created room ID.                      |

---

### **4. Post-conditions**  
- A new room is created in the system, associated with the logged-in user.
- The user is redirected to the home screen with the newly created room displayed.

---

### **5. Acceptance Criteria**  
- The user must be able to input a room name and create a room.
- A success message is shown when the room is created successfully.
- The user is redirected to the home page with the newly created room.
- If room creation fails, an appropriate error message is displayed.


---

# **Acceptance Test for RoomHub - Join Room Feature**

---

**Project Name:** RoomHub  
**Test Case ID:** Iteration 1  
**Test Title:** Join Room  


---

### **1. Purpose**  
To verify that a user can successfully send a request to join a room in RoomHub, and that the room owner receives a notification to accept or reject the request.

---

### **2. Pre-conditions**  
- The user is logged in and authenticated.
- A room exists, and the user has the correct email address of a roommate.

---

### **3. Test Steps**

| Step Number | Action Description                                      | Input Data                              | Expected Result                                                                                  |
|-------------|----------------------------------------------------------|-----------------------------------------|--------------------------------------------------------------------------------------------------|
| 1           | Open RoomHub app and navigate to the "Join a Room" section. | N/A                                     | The "Join a Room" form is displayed.                                                              |
| 2           | Enter a valid roommate's email in the "Roommate's email" field. | e.g., "roommate@example.com"            | The email address is accepted and displayed without error.                                        |
| 3           | Click the "Send Request" button.                          | N/A                                     | A request is sent to the backend to join the room.                                                |
| 4           | Verify that a success message is displayed if the join request is successful. | N/A                                 | A message like "Request sent" is displayed.                                                       |
| 5           | Verify that the room owner receives a notification with the option to accept or reject the request. | N/A                             | The room owner sees a notification with the message and buttons to accept or reject.              |
| 6           | Verify that the user is notified of acceptance, and they can now access the room. | N/A                                | Once accepted, the user can access the room, and a success message is displayed.                  |

---

### **4. Post-conditions**  
- The user successfully sends a request to join a room.
- The room owner receives a notification to accept the request.
- If accepted, the user is added to the room and can view the room.

---

### **5. Acceptance Criteria**  
- The user must be able to input a valid email address and send a request to join a room.
- A success message is displayed upon sending the request.
- The room owner receives a notification to accept the request.
- The user is added to the room once the request is accepted.
- If the request fails, an appropriate error message is displayed.

---



# **Acceptance Test for Notifications in RoomHub**

---

**Project Name:** RoomHub  
**Test Case ID:** Iteration1  
**Test Title:** Notifications Display and Action Handling  
---

### **1. Purpose**  
To verify that notifications in RoomHub are displayed correctly, users can interact with them, and accepting roommate requests are handled appropriately.

---

### **2. Pre-conditions**  
- RoomHub app is installed and running.
- User is logged in 

---
### **3. Test Steps**

| Step Number | Action Description                                        | Input Data                             | Expected Result                                                                                      |
|-------------|------------------------------------------------------------|----------------------------------------|------------------------------------------------------------------------------------------------------|
| 1           | Open RoomHub app and navigate to the Notifications page.  | N/A                                    | Notifications page is displayed, showing all the user’s current notifications.                        |
| 2           | Check if the notification list is displayed correctly when there are notifications. | A list of notifications              | Notifications are displayed in a scrollable list, with each item showing the notification message.     |
| 3           | Check the behavior when there are no notifications.       | N/A                                    | A message “No notifications” is displayed if the list is empty.                                       |
| 4           | Tap the "Accept" button on a notification for a new roommate request. | N/A                                  | Roommate is added successfully, a success message is displayed, and the notification is removed from the list. |

| 5           | Verify proper navigation on pressing the back button.     | N/A                                    | The user is returned to the previous page.                                                            |

---

### **4. Post-conditions**  
- Notifications are cleared from the list after interaction.

---

### **5. Acceptance Criteria**  
- Notifications must be displayed properly, even when there are no notifications.
- accepting a notification must perform correctly.
- User must be able to get back to the previous page 
