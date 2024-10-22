// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_frontend/widgets/gradient_button.dart';
import 'package:flutter_frontend/utils/our_theme.dart';
import 'package:flutter_frontend/screens/home/home_new_user.dart';
import 'package:flutter_frontend/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_frontend/utils/custom_exceptions.dart';
import 'package:flutter_frontend/utils/response_handler.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_frontend/config.dart';
import 'dart:convert';

// Stateful widget for joining a room
class JoinRoomForm extends ConsumerStatefulWidget {
  const JoinRoomForm({super.key});

  @override
  _JoinRoomFormState createState() => _JoinRoomFormState();
}

// State class for JoinRoomForm
class _JoinRoomFormState extends ConsumerState<JoinRoomForm> {
  final theme = OurTheme(); // Instance of our theme class
  TextEditingController emailController = TextEditingController(); // Controller for roommate's email input
  late String userEmail; // Variable to store the user's email

  @override
  void initState() {
    super.initState();
    // Email will be retrieved in the build method, no need for initialization here
  }

  @override
  Widget build(BuildContext context) {
    userEmail = ref.read(emailProvider); // Retrieve user's email from the provider

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient container
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                theme.mintgreen, // Gradient starting color
                theme.darkblue,  // Gradient ending color
              ]),
            ),
          ),
          // Positioned header with back button and title
          Positioned(
            top: 40.0,
            left: 20.0,
            right: 20.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button to return to the previous screen
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Pop the current screen
                  },
                ),
                // Title text indicating the purpose of the screen
                const Text(
                  '\nRequest to join\n A Room',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
          // Main content container for instructions and email input
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white, // Background color for the input area
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // First Instruction
                    _buildInstruction(1, "Enter your roommate's email"),
                    const SizedBox(width: 50), // Space between instructions

                    // Second Instruction
                    _buildInstruction(2, "A notification request will be sent to their profile"),
                    const SizedBox(width: 50), // Space between instructions

                    // Third Instruction
                    _buildInstruction(3, "Once they accept, you are in!"),
                    const SizedBox(height: 30), // Spacer below instructions

                    // TextField for roommate's email input
                    TextField(
                      controller: emailController, // Controller for email input
                      cursorColor: theme.darkblue, // Cursor color
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.alternate_email,
                          color: Colors.grey, // Icon color
                        ),
                        label: Text(
                          "Roommate's email", // Label for the email input
                          style: TextStyle(color: theme.darkblue), // Label color
                        ),
                      ),
                    ),
                    const SizedBox(height: 50), // Spacer below text field

                    // Button to send the request
                    GradientButton(
                      text: 'Send Request',
                      onTap: () async {
                        // When the button is tapped, try to join the room
                        if (await joinRoomBE()) {
                          // Show success message
                          theme.buildToastMessage("Request sent");
                          // Navigate to the home screen after a short delay
                          Future.delayed(const Duration(seconds: 1), () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const OurHomeNewUser(),
                              ),
                            );
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 50), // Spacer below button
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build instruction rows
  Widget _buildInstruction(int step, String instruction) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ' $step ', // Step number
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 60,
            color: theme.mintgreen, // Green color for the step number
          ),
        ),
        Expanded(
          child: Text(
            '\n$instruction\n\n', // Instruction text
            softWrap: true, // Allow text to wrap
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: theme.darkblue, // Blue color for the instruction text
            ),
          ),
        ),
      ],
    );
  }

  // Function to handle room joining backend request
  Future<bool> joinRoomBE() async {
    bool createSuccess = false; // Variable to track success of joining
    try {
      // Prepare the request body with sender and recipient email
      var regBody = {
        "from": userEmail, // User's email (sender)
        "to": emailController.text, // Roommate's email (recipient)
        "type": 'join-request', // Request type
      };
      // Send POST request to join the room
      var response = await http.post(
        Uri.parse(joinRoom), // URL for joining a room
        headers: {"Content-Type": "application/json"}, // Set content type
        body: jsonEncode(regBody), // Encode the request body as JSON
      );

      // Handle the response
      await handlePost(response, responseType: 'joinRoom'); // Process response
      createSuccess = true; // Set success if no exceptions occur
    } on NotificationException catch (e) {
      // Handle any NotificationException errors
      theme.buildToastMessage(e.message); // Show error message
    }
    return createSuccess; // Return success status
  }
}

