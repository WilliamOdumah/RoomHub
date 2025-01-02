// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_frontend/widgets/gradient_button.dart';
import 'package:flutter_frontend/utils/our_theme.dart';
import 'package:flutter_frontend/screens/home/home.dart';
import 'package:flutter_frontend/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_frontend/utils/custom_exceptions.dart';
import 'package:flutter_frontend/utils/response_handler.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_frontend/config.dart';
import 'dart:convert';

class CreateRoomForm extends ConsumerStatefulWidget {
  const CreateRoomForm({super.key});

  @override
  _CreateRoomFormState createState() => _CreateRoomFormState();
}

class _CreateRoomFormState extends ConsumerState<CreateRoomForm> {
  final theme = OurTheme();
  final TextEditingController nameController = TextEditingController();
  late String userEmail;

  @override
  void initState() {
    super.initState();
    // Retrieve the email from the provider
    userEmail = ref.read(emailProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.mintgreen, theme.darkblue],
              ),
            ),
          ),
          // Header with back button and title
          Positioned(
            top: 10.0,
            left: 20.0,
            right: 20.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Go back to previous screen
                  },
                ),
                // Title
                const Text(
                  '\nCreating your\n Room',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          // Main content container
          Padding(
            padding: const EdgeInsets.only(top: 160.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 10.0, top: 50.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Instructions
                      _buildInstruction("1", "Assign a name to your room"),
                      const SizedBox(width: 50),
                      _buildInstruction("2", "Tell your roommates to join"),
                      const SizedBox(width: 50),
                      _buildInstruction("3", "Accept their request"),
                      const SizedBox(height: 10),
                  
                      // Text field for room name input
                      TextField(
                        controller: nameController,
                        cursorColor: theme.darkblue,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.house_outlined,
                            color: Colors.grey,
                          ),
                          label: Text(
                            ' Name',
                            style: TextStyle(color: theme.darkblue),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                  
                      // Create Room button
                      GradientButton(
                        text: 'Create Room',
                        onTap: () async {
                          if (await createRoomBE()) {
                            theme.buildToastMessage("Room successfully created");
                            Future.delayed(const Duration(seconds: 1), () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => OurHome(roomID: nameController.text ,email: userEmail),
                                ),
                              );
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build instruction rows
  Widget _buildInstruction(String step, String instruction) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$step ', // Step number
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 60,
            color: theme.mintgreen, // Green color for the number
          ),
        ),
        Expanded(
          child: Text(
            '\n$instruction\n\n', // Instruction text
            softWrap: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: theme.darkblue, // Blue color for the text
            ),
          ),
        ),
      ],
    );
  }

  // Function to handle room creation
  Future<bool> createRoomBE() async {
    bool createSuccess = false;
    try {
      // Prepare the request body
      var regBody = {"rm": nameController.text, "id": userEmail};
      var response = await http.post(
        Uri.parse(createRoom),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );

      // Handle the response
      await handlePost(response, responseType: 'createRoom');
      createSuccess = true;
    } on RoomException catch (e) {
      // Display error message
      theme.buildToastMessage(e.message);
    }
    return createSuccess;
  }
}
