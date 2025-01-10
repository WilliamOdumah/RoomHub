/*import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_frontend/config.dart';
import 'package:flutter_frontend/screens/transactionManagement/all_transactions.dart';
import 'package:flutter_frontend/widgets/side_menu.dart';
import 'package:flutter_frontend/widgets/header.dart';
import 'package:flutter_frontend/utils/our_theme.dart';

import '../utils/custom_exceptions.dart';
import '../utils/response_handler.dart';
import 'taskManagement/all_task.dart';
import 'package:http/http.dart' as http;

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

  @override
  void initState() {
    super.initState();
    getSummary(widget.email); // async function here
  }

  @override
  Widget build(BuildContext context) {
    // update the boiz with the valid roomID
    return Scaffold(
      backgroundColor: theme.lightgrey,
      drawer: Navbar(roomId: widget.roomID, email: widget.email),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Header(roomId: widget.roomID),
          const SizedBox(
            height: 100,
          ),
          SizedBox(
            width: 300,
            height: 150,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AllTasks(
                      email: widget.email,
                      roomId: widget.roomID,
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 0,
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(colors: [
                        theme.mintgreen, // Gradient starting color
                        theme.darkblue, // Gradient ending color
                      ]),
                    ),
                    child: const Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .center, // Aligns text to the center
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Centers text vertically
                        children: [
                          Text(
                            "TASKS",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                        ]),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 100,
          ),
          summaryData == null
              ? const Center(
                  child: SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator()))
              : SizedBox(
                  width: 300,
                  height: 150,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SharedExpensesPage(
                              userId: widget.email,
                              roomId: widget.roomID,
                              summary: summaryData!),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 0,
                      color: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(colors: [
                            theme.mintgreen, // Gradient starting color
                            theme.darkblue, // Gradient ending color
                          ]),
                        ),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text(
                                "SHARED EXPENSES",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Row(
                              // crossAxisAligment: CrossAxisAlignment.
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '\$${owe!}', // e.g., "29"
                                      style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      "You owe", // e.g., "Aug"
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 30),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '\$${owed!}', // e.g., "29"
                                      style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      "You are owed", // e.g., "Aug"
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      )),
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
}
*/