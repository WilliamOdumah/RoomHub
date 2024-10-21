import 'package:http/http.dart' as http;
import 'package:flutter_frontend/utils/custom_exceptions.dart';
import 'dart:convert';

// This function handles the response for different types of POST requests 
// and throws custom exceptions based on the response status and content.
Future<void> handlePost(http.Response response,
    {required String responseType}) async {
  switch (responseType) {
    case 'signup':
      switch (response.statusCode) {
        case 200:
          // Handle case where the username already exists
          if (response.body == "This user name already exist") {
            throw UserException("This username already exists");
          }
          break;
        case 400:
          // Handle invalid email scenario
          throw UserException("Error Creating User - Email is invalid");
        case 500:
          // Generic error for server issues
          throw UserException("Something went wrong. Try again later");
        default:
          // Fallback error for any other status codes
          throw UserException("Something went wrong. Try again later");
      }
      break;

    case 'createRoom':
      switch (response.statusCode) {
        case 400:
          // Check for specific error messages in the response body
          if (response.body.contains("Invalid Room Name")) {
            throw RoomException("Invalid Room Name");
          } else if (response.body.contains("Invalid User")) {
            throw RoomException("Invalid User");
          }
          break;
        case 500:
          // Server error during room creation
          throw RoomException("Something went wrong. Try again later");
      }
      break;

    case 'addRoommate':
      switch (response.statusCode) {
        case 404:
          // Check for specific user or room not found messages
          if (response.body.contains("Room not found")) {
            throw UserException("Room not found");
          } else if (response.body.contains("User not found")) {
            throw UserException("User not found");
          } else if (response.body.contains("New roommate not found")) {
            throw UserException("New roommate not found");
          } else if (response.body.contains("Old roommate not found")) {
            throw UserException("Old roommate not found");
          }
          break;
        case 500:
          // Log server error, better to throw exception for consistency
          print("Something went wrong. Try again later");
          break;
      }
      break;

    case 'joinRoom':
      switch (response.statusCode) {
        case 404:
          // Handle case where the user is not found
          if (response.body.contains("User not found")) {
            throw NotificationException('User not found');
          }
          break;
        case 400:
          // Handle case where the notification message is empty
          if (response.body.contains("Message is empty")) {
            throw NotificationException(
                'Error Creating Notification - Message is empty');
          }
          break;
        case 500:
          // Server error for join room request
          throw NotificationException('Something went wrong. Try again later');
      }
      break;
  }
}

// This function handles GET requests and returns the desired value from the response body.
// It also handles and throws custom exceptions based on status codes and response content.
Future<String> getResponse(http.Response response,
    {required String responseType}) async {
  // Uncomment these for debugging purposes
  // print(response.body);
  // print(response.statusCode);

  switch (responseType) {
    case 'getUserRoom':
      switch (response.statusCode) {
        case 200:
          // Decode JSON response and return the room name if it exists
          var jsonResponse = jsonDecode(response.body);
          if (jsonResponse.containsKey('room_name')) {
            return jsonResponse['room_name'];
          } else {
            throw UserException('Room name not found in the response');
          }
        case 400:
          // Handle invalid username scenario
          if (response.body.contains("Invalid username")) {
            throw UserException('This username is invalid');
          }
          throw UserException('Invalid request');
        case 404:
          // Handle user not found scenario
          throw UserException('User not found');
        case 500:
          // Server error
          throw UserException('Something went wrong. Try again later');
        default:
          // Handle unexpected status codes
          throw UserException('Unexpected status code: ${response.statusCode}');
      }

    case 'getUserNotification':
      switch (response.statusCode) {
        case 400:
          // Handle invalid username error
          if (response.body.contains("Invalid username")) {
            throw UserException('Invalid username');
          }
          throw UserException('Invalid request');
        case 500:
          // Server error
          throw UserException('Something went wrong. Try again later');
        default:
          // Handle unexpected status codes
          throw UserException('Unexpected status code: ${response.statusCode}');
      }

    default:
      // Fallback for unknown responseType
      throw Exception('Something went wrong. Try again later');
  }
}
