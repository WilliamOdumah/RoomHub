import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_frontend/config.dart';
import 'package:flutter_frontend/screens/room_page.dart';
import 'package:flutter_frontend/screens/transactionManagement/create_expense.dart';
import 'package:flutter_frontend/screens/transactionManagement/settle_up.dart';
import 'package:flutter_frontend/utils/our_theme.dart';
import 'package:http/http.dart' as http;

import '../../utils/custom_exceptions.dart';
import '../../utils/response_handler.dart';

class SharedExpensesPage extends StatefulWidget {
  final String userId;
  final String roomId;

  const SharedExpensesPage(
      {super.key,
      required this.userId,
      required this.roomId,
      });

  @override
  _SharedExpensesPageState createState() => _SharedExpensesPageState();
}

class _SharedExpensesPageState extends State<SharedExpensesPage> {
  @override
  void initState() {
    super.initState();
    getSummary(widget.userId);
    getTransactions(widget.userId); // async function here
    // extractSummaryInfo(widget.summary);
  }

  List<Transaction>? allTransactions;
   Map<String, dynamic>? summaryData;
  // Sample transaction data

  double? owe;
  double? owed;

  List<dynamic>? summaryMessages;
  // List of dynamic text boxes for the summary section
  // final List<String> summaryMessages = [
  //   "Bobby owes you \$20",
  //   "Bobby owes you \$20",
  //   "You owes Bobby \$20",
  //   // Add more summary messages as needed
  // ];

  // double amountUserOwes = (summary["owed"] as num).toDouble();
  // double amountUserIsOwed = (jsonData["owns"] as num).toDouble();

  // double owe = double.parse(amountUserOwes.toStringAsFixed(2));
  // double owed = double.parse(amountUserIsOwed.toStringAsFixed(2));

  final theme = OurTheme();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Back button to return to the previous screen
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 0.0, top: 20.0, bottom: 0.0),
            child: Stack(children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: theme.darkblue,
                  size: 30,
                ),
                onPressed: () {
                  print("popping transaction page");
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => UserRoom(
                      email: widget.userId,
                      roomID: widget.roomId,
                    ),
                  ));
                },
              ),
              Center(
                child: 
                Padding(
                  padding: const EdgeInsets.only(
                left: 0, right: 0.0, top: 20.0, bottom: 0.0),
                  child: Text(
                    widget.roomId,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: theme.darkblue),
                  ),
                ),
              )
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 10.0, bottom: 2.0),
            child: 
            owe == null || owed == null || summaryMessages == null ?
              const Center(
              child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator())) 
                        :
              Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(colors: [
                  theme.mintgreen, // Gradient starting color
                  theme.darkblue, // Gradient ending color
                ]),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 10.0, top: 15.0, bottom: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(                      
                      // crossAxisAligment: CrossAxisAlignment.
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              "\$${owe!}", // e.g., "29"
                              style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            const Text(
                              "You owe", // e.g., "Aug"
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(width: 50),
                        Column(
                          children: [
                            Text(
                              "\$${owed!}", // e.g., "29"
                              style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              "You are owed", // e.g., "Aug"
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    // Generate a Text widget for each summary message
                    ...summaryMessages!.map((message) => Padding(
                          padding: const EdgeInsets.only(bottom: 2.0),
                          child: Center(
                            child: Text(
                              message,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )),
                    const SizedBox(height: 15),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SettleUp(
                                    email: widget.userId,
                                    roomId: widget.roomId,
                                    summaryData: summaryData!,
                                  ),
                                ),
                              );
                              debugPrint("Settle up clicked");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.darkblue,
                              // fixedSize: const Size(100, 30), // Minimum width and height
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 2.0), // Padding
                            ),
                            child: const Text(
                              "Settle Up",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => ExpenseForm(
                                          email: widget.userId,
                                          roomId: widget.roomId,
                                          summaryData: summaryData!,
                                        )),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.darkblue,
                              // fixedSize: const Size(100, 30), // Minimum width and height
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0), // Padding
                            ),
                            child: const Text(
                              "Add Expense",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ]),
                  ],
                ),
              ),
            ),
          ),
          // Title Text Box
          const Padding(
            padding:
                EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0, bottom: 5),
            child: Center(
              child: Text(
                'All Transactions',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // Transactions List
          Expanded(
            child: allTransactions == null
                ? const Center(
                    child: SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator()))
                : allTransactions!.isEmpty
                    ? const Center(child: Text("No Transactions at the moment"))
                    : ListView.builder(
                        padding: EdgeInsets.zero, // Removes default padding
                        itemCount: allTransactions!.length,
                        itemBuilder: (context, index) {
                          final transaction = allTransactions![index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 2.0, vertical: 2.0),
                            child: Card(
                              elevation: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: transaction.transactionType == "expense"
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Date Display (Month and Day)
                                          Column(
                                            children: [
                                              Text(
                                                transaction
                                                    .getMonth(), // e.g., "Aug"
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: theme.darkblue),
                                              ),
                                              Text(
                                                transaction
                                                    .getDay(), // e.g., "29"
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: theme.darkblue),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(
                                              width:
                                                  50), // Spacer between details and lending info

                                          // Transaction Details
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  capitalize(transaction
                                                      .transactionName), // e.g., "Groceries"
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: theme.darkblue),
                                                  overflow: TextOverflow
                                                      .ellipsis, // Prevents overflow for long names
                                                ),
                                                Text(
                                                  transaction.paidToString(
                                                      widget.userId),
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: theme.darkblue),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                              width:
                                                  16), // Spacer between details and lending info

                                          // Lending Details
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  transaction.lentToString(widget
                                                      .userId), // e.g., "You lent CAD 50"
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: theme.darkblue),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          // Date Display (Month and Day)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 40),
                                            child: Column(
                                              children: [
                                                Text(
                                                  transaction
                                                      .getMonth(), // e.g., "Aug"
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: theme.darkblue),
                                                ),
                                                Text(
                                                  transaction
                                                      .getDay(), // e.g., "29"
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: theme.darkblue),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Transaction Details
                                          Flexible(
                                            child: Text(
                                              transaction
                                                  .transactionName, // e.g., "Groceries"
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: theme.darkblue),
                                              softWrap: true,
                                              overflow: TextOverflow.visible,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  void getTransactions(String userId) async {
    try {
      var response = await http.get(
        Uri.parse("$getTransactionPth?id=$userId"),
        headers: {"Content-Type": "application/json"},
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        List<Transaction> transactions = Transaction.parseTransaction(jsonData);
        for (var transaction in transactions) {
          print(transaction); // This will call the toString method
        }
        setState(() {
          allTransactions = transactions;
        });
        // result = transactions;
      } else {
        await getResponse(response, responseType: 'getTransactions');
      }
    } on UserException catch (e) {
      print(e.toString());
      OurTheme().buildToastMessage(e.message);
    }
  }

  String capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  void extractSummaryInfo(Map<String, dynamic> summary) {
    double amountUserOwes = (summary["owed"] as num).toDouble();
    double amountUserIsOwed = (summary["owns"] as num).toDouble();
    owe = double.parse(amountUserOwes.toStringAsFixed(2));
    owed = double.parse(amountUserIsOwed.toStringAsFixed(2));
    summaryMessages = summary["relationships"];
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
          summaryMessages = jsonData['relationships'];
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

class Transaction {
  final String transactionFullDate;
  final String transactionName;
  final String transactionType;
  final String payer;
  double? amountPaid;
  double? amountLent;

  // List of month names
  List<String> monthNames = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  Transaction({
    required this.transactionFullDate, // date format yyyy-mm-dd
    required this.transactionName,
    required this.transactionType,
    required this.payer,
    this.amountPaid,
    this.amountLent,
  });

  // Factory constructor to create a NotificationItem from JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    print(json);
    // based on the transaction type paid by creator and owed to creator exists.
    String transactionType = json['type'];

    double? amountPaid;
    double? amountLent;
    if (transactionType == "expense") {
      amountPaid = (json["paid_by_creator"] as num).toDouble();
      amountLent = (json["owed_to_creator"] as num).toDouble();
    }

    return Transaction(
        transactionFullDate: json['transaction_date'],
        transactionName: json['transaction_name'],
        transactionType: transactionType,
        payer: json['creator'].toLowerCase(),
        amountPaid: amountPaid,
        amountLent: amountLent);
  }

  static List<Transaction> parseTransaction(Map<String, dynamic> json) {
    // Access the 'pending/complete tasks' array
    List<dynamic> transactions = json["All_Transactions"];

    // Map the list of JSON objects to Task objects
    List<Transaction> all_transactions = transactions.map((item) {
      return Transaction.fromJson(item as Map<String, dynamic>);
    }).toList();

    return all_transactions;
  }

  String lentToString(String currUser) {
    String result = "";
    if (amountLent == null) {
      return "";
    }

    if (currUser.toLowerCase() == payer.toLowerCase()) {
      result = "You lent \$$amountLent";
    } else {
      result = "${payer.toLowerCase()} lent \$$amountLent";
    }
    return result;
  }

  String paidToString(String currUser) {
    String result = "";
    if (amountPaid == null) {
      return result;
    }

    if (currUser.toLowerCase() == payer.toLowerCase()) {
      result = "You paid \$$amountPaid";
    } else {
      result = "${payer.toLowerCase()} paid \$$amountPaid";
    }
    return result;
  }

  String getMonth() {
    List<String> dateAsList = transactionFullDate.split("-");
    int? monthIndex = int.tryParse(dateAsList[1]);
    // Ensure the number is between 1 and 12
    if (monthIndex == null || monthIndex < 1 || monthIndex > 12) {
      return "Invalid month";
    }

    // Get the month name using DateTime
    return monthNames[monthIndex - 1].substring(0, 3);
  }

  String getDay() {
    List<String> dateAsList = transactionFullDate.split("-");
    return dateAsList[2];
  }

  // Override toString method to provide a string representation for the transaction
  @override
  String toString() {
    return 'Task{'
        'Transaction Name: $transactionName'
        'Transaction type:$transactionType'
        'Transaction date: $transactionFullDate'
        '}';
  }
}
