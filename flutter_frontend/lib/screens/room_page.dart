// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/createAnnouncement/create_announcement_page.dart';
import 'package:flutter_frontend/screens/reviewRoommate/review_roommate.dart';
import 'package:flutter_frontend/screens/taskManagement/all_task.dart';
import 'package:flutter_frontend/screens/transactionManagement/all_transactions.dart';
import 'package:flutter_frontend/screens/userProfile/create_profile.dart';
import 'package:flutter_frontend/screens/userProfile/update_profile.dart';
import 'package:flutter_frontend/widgets/button.dart';
import 'package:flutter_frontend/widgets/gradient_button.dart';
import 'package:flutter_frontend/utils/our_theme.dart';
import 'package:flutter_frontend/screens/home/home_new_user.dart';
import 'package:flutter_frontend/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_frontend/utils/custom_exceptions.dart';
import 'package:flutter_frontend/utils/response_handler.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_frontend/config.dart';
import 'package:flutter_frontend/widgets/header.dart';
import 'dart:convert';

class UserRoom extends StatefulWidget {
  final String roomID;
  final String email;
  const UserRoom({super.key, required this.roomID, required this.email});

  @override
  State<UserRoom> createState() => _UserRoomState();
}

class _UserRoomState extends State<UserRoom> {
  final theme = OurTheme();
  final List<String> homeCards = ["Tasks"];
  double? owe;
  double? owed;
  Map<String, dynamic>? summaryData;

  List<String> descriptions = [
    "Stay on top of household chores by assigning and tracking tasks for everyone in the room.",
    "Easily manage shared expenses and split costs among roommates.",
    "Share important updates or reminders with all roommates in one place.",
    "Rate roommates, average reviews are displayed on user profiles to inform future roommates."
  ];

  List<String> titles = [
    "Task Organizer",
    "Expense Calculator",
    "Create Announcements",
    "Review Roommates"
  ];

  List<String> icons = [
    "assets/task.png",
    "assets/expense.png",
    "assets/announce.png",
    "assets/review.png"
  ];
  late bool hasProf = false;

  @override
  void initState() {
    super.initState();
    hasProfile(widget.email);
     getSummary(widget.email); // async function here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            Header(roomId: widget.roomID),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
              child: Column(
                children: List.generate(titles.length, (index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 15.0), // Increased padding
                    margin: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.darkblue,
                          theme.mintgreen,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5.0,
                          spreadRadius: 1.0,
                          offset: Offset(4.0, 4.0),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title aligned to start
                        Text(
                          titles[index],
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),

                        // Row for text, button, and icon
                        Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    descriptions[index],
                                    softWrap: true,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  MyButton(
                                    text: "Continue",
                                    onTap: () {
                                      // Add redirection logic based on index
                                      if (index == 0) {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => AllTasks(
                                              email: widget.email,
                                              roomId: widget.roomID,
                                            ),
                                          ),
                                        );
                                      } else if (index == 1) {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SharedExpensesPage(
                                              userId: widget.email,
                                              roomId: widget.roomID,
                                            ),
                                          ),
                                        );
                                      } else if (index == 2) {
  Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CreateAnnouncement(email: widget.email),
                  ),
                );
}
 else if (index == 3) {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => ReviewForm(
                                              email: widget.email,
                                              roomId: widget.roomID,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Image.asset(
                                icons[index],
                                width: 95.0,
                                height: 110.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getSummary(String userId) async {
    try {
      var response = await http.get(
        Uri.parse("$getSummaryPth?id=$userId"),
        headers: {"Content-Type": "application/json"},
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        print(jsonData);
        // for (var transaction in transactions) {
        //   print(transaction); // This will call the toString method
        // }yo
        // amount user owes
        double amountUserOwes = (jsonData["owed"] as num).toDouble();
        double amountUserIsOwed = (jsonData["owns"] as num).toDouble();
        setState(() {
          owe = double.parse(amountUserOwes.toStringAsFixed(2));
          owed = double.parse(amountUserIsOwed.toStringAsFixed(2));
          summaryData = jsonData;
          // allTransactions = transactions;
        });
        // result = transactions;
      } else {
        await getResponse(response, responseType: 'getSummary');
      }
    } on UserException catch (e) {
      print(e.toString());
      OurTheme().buildToastMessage(e.message);
    }
  }

  Future<bool> hasProfile(String userId) async {
    try {
      var response = await http.get(
        Uri.parse("$user/$userId/$findRoomMatePage"),
        headers: {"Content-Type": "application/json"},
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        hasProf = true;
      }
    } on ProfileException catch (e) {
      print(e.toString());
      return false;
    }
    return hasProf;
  }
}
