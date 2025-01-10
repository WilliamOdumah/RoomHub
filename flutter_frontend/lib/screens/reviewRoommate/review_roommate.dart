//  Slider(
//             value: _currentSliderSecondaryValue,
//             label: _currentSliderSecondaryValue.round().toString(),
//             onChanged: (double value) {
//               setState(() {
//                 _currentSliderSecondaryValue = value;
//               }
//               );

import 'dart:convert';

import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_frontend/screens/room_page.dart';
import 'package:flutter_frontend/utils/our_theme.dart';
import "package:flutter_frontend/widgets/gradient_button.dart";
import 'package:http/http.dart' as http;
import 'package:flutter_frontend/utils/response_handler.dart';
import 'package:flutter_frontend/config.dart';

import '../../utils/custom_exceptions.dart';

class ReviewForm extends StatefulWidget {
  final String email;
  final String roomId;

  const ReviewForm({super.key, required this.email, required this.roomId});

  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  final theme = OurTheme();
  String? selectedRoommate;
  String? _assigneeError;
  List<dynamic> roomMates = [];
  bool isLoading = true;

  Map<String, int> ratings = {
    "overall": 3,
    "cleanliness": 3,
    "noise_levels": 3,
    "respect": 3,
    "communication": 3,
    "paying_rent": 3,
    "chores": 3,
  };

  @override
  void initState() {
    super.initState();
    getRoommatesCaller();
  }

  Future<void> getRoommatesCaller() async {
    // Simulate an API request or some async operation
    List<dynamic> allRoommates = await getRoommates();
    for (dynamic roommate in allRoommates) {
      if (roommate[0] != widget.email) {
        roomMates.add(roommate);
      }
    }

    // roomMates = [["dan@gmail.com","daniel"], ["lola@gmail.com","lola"], ["cheeto@gmail.com","cheeto"]];
    // Update the loading state and rebuild the UI
    setState(() {
      isLoading = false; // Update loading state
    });
  }

  Future<List<dynamic>> getRoommates() async {
    List<dynamic> result = [];
    print(widget.email);
    try {
      var response = await http.get(
        Uri.parse("$user/${widget.email}/$getRoommatesList"),
        headers: {"Content-Type": "application/json"},
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        List<dynamic> roommates = jsonData['all_roommates'];
        result = roommates;
      } else {
        await getResponse(response, responseType: 'getRoommateList');
      }
    } on UserException catch (e) {
      OurTheme().buildToastMessage(e.message);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
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
                theme.darkblue, // Gradient ending color
              ]),
            ),
          ),
          // Positioned custom header with back button and title
          Positioned(
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
                  '\nReview Your\nRoommate',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
          // Main content container for review form
          Padding(
            padding: const EdgeInsets.only(
                top: 160.0), // Add top padding to avoid overlap
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
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Add form elements or sliders here (example)
                      const SizedBox(
                        height: 20.0,
                      ),
                      // Example dropdown for selecting roommate
                      DropdownButtonFormField<String>(
                        value: selectedRoommate,
                        icon: const Icon(Icons.arrow_drop_down),
                        decoration: InputDecoration(
                          label: roomMates.isEmpty
                              ? Text(
                                  "No roommates",
                                  style: TextStyle(color: theme.darkblue),
                                )
                              : Text(
                                  "Choose Roommate",
                                  style: TextStyle(color: theme.darkblue),
                                ),
                          errorText: _assigneeError,
                        ),
                        items: roomMates
                            .map<DropdownMenuItem<String>>((dynamic value) {
                          return DropdownMenuItem<String>(
                              value: value[0], child: Text(value[1]));
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedRoommate = newValue;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      // Add other form widgets (like sliders) below
                      // Example of a slider
                      // Sliders for each rating category
                      buildRatingSlider('Overall', 'overall'),
                      buildRatingSlider('Cleanliness', 'cleanliness'),
                      buildRatingSlider('Noise Levels', 'noise_levels'),
                      buildRatingSlider('Respect', 'respect'),
                      buildRatingSlider('Communication', 'communication'),
                      buildRatingSlider('Paying Rent', 'paying_rent'),
                      buildRatingSlider('Chores', 'chores'),
                      // Example save button
                      GradientButton(
                        text: 'Save Review',
                        onTap: () async {
                          bool isSaved = await saveReview(context);
                          if (isSaved) {
                            print("Should be changing the page");
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => UserRoom(
                                  roomID: widget.roomId,
                                  email: widget.email,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 60)
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

  Future<bool> saveReview(BuildContext context) async {
    bool isSaved = false;
    try {
      // Create a list of ratings to pass to the sendReview method
      List<int> ratingsList = [
        ratings['overall']!,
        ratings['cleanliness']!,
        ratings['noise_levels']!,
        ratings['respect']!,
        ratings['communication']!,
        ratings['paying_rent']!,
        ratings['chores']!,
      ];
      if(roomMates.isNotEmpty){
        await sendReview(
          reviewedBy: widget.email,
          reviewed: selectedRoommate!,
          ratings: ratingsList); // Pass the list
      isSaved = true;
      }else{
        theme.buildToastMessage("No roommates to review");
        isSaved = false;
      }
    } catch (e) {
      theme.buildToastMessage("Something went wrong. Please try again later");
      isSaved = false;
    }
    return isSaved;
  }

  Future<void> sendReview({
    required String reviewedBy, // The ID of the user submitting the review
    required String reviewed, // The ID of the user being reviewed
    required List<int> ratings, // List of ratings (overall, cleanliness, etc.)
  }) async {
    try {
      // Request body with ratings in a list
      var reqBody = {
        "reviewed_by": reviewedBy,
        "reviewed": reviewed,
        "overall": ratings[0], // First element for overall rating
        "cleanliness": ratings[1], // Second element for cleanliness
        "noise_levels": ratings[2], // Third element for noise levels
        "respect": ratings[3], // Fourth element for respect
        "communication": ratings[4], // Fifth element for communication
        "paying_rent": ratings[5], // Sixth element for paying rent
        "chores": ratings[6], // Seventh element for chores
      };

      print("Request Body: $reqBody");

      // HTTP POST request
      var response = await http.post(
        Uri.parse("$user/send-review"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody),
      );

      // Handle response
      if (response.statusCode == 200) {
        theme.buildToastMessage("Review submitted successfully.");
        // Kick back to the notification page or perform additional actions
      } else {
        throw UserException("Failed to submit review: ${response.body}");
      }
    } on UserException catch (e) {
      theme.buildToastMessage(e.message);
      rethrow;
    } catch (e) {
      print("Unexpected error: $e");
      theme.buildToastMessage("An unexpected error occurred.");
    }
  }

  Widget buildRatingSlider(String label, String key) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              color: theme.darkblue, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Slider(
          value: ratings[key]!.toDouble(),
          min: 1,
          max: 5,
          divisions: 4,
          activeColor: theme.darkblue,
          inactiveColor: theme.lightgrey,
          label: ratings[key].toString(),
          onChanged: (value) {
            setState(() {
              ratings[key] = value.toInt();
            });
          },
        ),
        const SizedBox(
          height: 20.0,
        ),
      ],
    );
  }
}
