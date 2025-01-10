
import 'dart:convert';

import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_frontend/screens/transactionManagement/all_transactions.dart';
import 'package:flutter_frontend/utils/our_theme.dart';
import "package:flutter_frontend/widgets/gradient_button.dart";
import 'package:http/http.dart' as http;
import 'package:flutter_frontend/utils/response_handler.dart';
import 'package:flutter_frontend/config.dart';

import '../../utils/custom_exceptions.dart';
import '../../widgets/multi_select_checkbox.dart';


class ExpenseForm extends StatefulWidget {
  final String email;
  final String roomId;
  final Map<String, dynamic> summaryData;
  const ExpenseForm({super.key, required this.email, required this.roomId, required this.summaryData});

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final theme = OurTheme();
  TextEditingController _expenseNameController = TextEditingController();
  // final List<String> roomMates= ["danny@gmail.com","dd@gmail.com", "lola@gmail.com"];
  DateTime? selectedDate;
  TextEditingController _dateController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  String? _taskNameError; // Error message for task name field
  String? _dateError;       // Error message for date field
  String? _contributorError; //Error message for the list of contributors.
  String? _amountError; //Error message for the amount field.

  List<dynamic> contributors = [];
  List<dynamic> potentialContributors = [];
  bool isLoading = true; // Track loading state


  @override
  void initState() {
    super.initState();
    getRoommatesCaller();
  }

  void updateContributors(List<dynamic> newContributors){
    contributors = newContributors;
    print(contributors);
  }


  Future<void> getRoommatesCaller() async {
    // Simulate an API request or some async operation
    List<dynamic> all_roommates = await getRoommates();
    // List<dynamic> all_roommates = [["dan@gmail.com","daniel"],["dolo@gmail.com","Dolo"],["kola@gmail.com","kola"]];
    // update this to use a list of lists-- [id,name]
    for(dynamic roommate in all_roommates){
      if(roommate[0] != widget.email){
        // add the full list to the list of contributors
        potentialContributors.add(roommate);
      }
    }


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

  // date selection
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child){
        return Theme(data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: OurTheme().darkblue,
            onPrimary: Colors.white,
            onSurface: OurTheme().darkblue
          ),
          dialogBackgroundColor: Colors.white
        ), child: child!
        );
      }
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        _dateController.text = "${pickedDate.toLocal()}".split(' ')[0]; // Formatting date
      });
    }
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
                theme.darkblue,  // Gradient ending color
              ]),
            ),
          ),
          // Positioned header with back button and title
          Positioned(
            left: 20.0,
            right: 20.0,
            child: Padding(
              padding: EdgeInsets.only(top: 5),
              child: Stack(
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
                  const Center(
                    child: Text(
                      '\nTransaction\n Management',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Main content container for instructions and email input
          Padding(
            padding: const EdgeInsets.only(top: 155.0),
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
                      const SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Text("Create Expense",
                            style: TextStyle(
                              color: theme.darkblue,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,)
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: _expenseNameController,
                        cursorColor: theme.darkblue,
                        decoration: InputDecoration(
                            label: Text(
                              "Expense Name",
                              style: TextStyle(color: theme.darkblue),
                            ),
                            errorText: _taskNameError
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: _amountController,
                        cursorColor: theme.darkblue,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), // Allows digits and a single decimal point
                        ],
                        decoration: InputDecoration(
                            label: Text(
                              "Expense Amount",
                              style: TextStyle(color: theme.darkblue),
                            ),
                            errorText: _amountError
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      MultiSelectFormField(options: potentialContributors, errorState: _contributorError,updateChoices: updateContributors, hint: 'Contributors',),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: _dateController,
                        cursorColor: theme.darkblue,
                        readOnly: true,
                        onTap: () => _selectDate(context), // Show date picker on tap
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.calendar_today),
                          label: Text(
                            "Date",
                            style: TextStyle(color: theme.darkblue),
                          ),
                          errorText: _dateError,
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      GradientButton(text: 'Save',
                          onTap: () async{
                            bool isSaved = await saveExpense(context);
                            if(isSaved){
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => SharedExpensesPage(userId: widget.email, roomId: widget.roomId),
                                ),
                              );
                            }
                          }),
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

  bool _validateFields() {
    setState(() {
      // Check if the name field is empty
      _taskNameError = _expenseNameController.text.isEmpty ? 'This field is required' : null;
      // Check if the email field is empty
      _dateError = _dateController.text.isEmpty ? 'This field is required' : null;
      _contributorError = contributors.isEmpty ? 'This field is required. Select at least 1 contributor' : null;
      _amountError = _amountController.text.isEmpty ? 'This field is required' : null;
    });

    // If all fields are valid, proceed
    if (_taskNameError == null && _contributorError == null && _dateError == null && _amountError == null) {
      // Proceed with form submission
      // You can add your submission logic here
      return true;
    }
    else{
      return false;
    }
  }

  Future<bool> saveExpense(BuildContext context) async{
    bool isSaved = false;
    try{
      if(_validateFields()){
        debugPrint("Add backend stuff to create a new task");
        await createNewExpense(widget.email, _expenseNameController.text, contributors, _dateController.text, _amountController.text);
        isSaved = true;
      }
    } catch (e){
      theme.buildToastMessage("Something went wrong. Please try again later");
      isSaved = false;
    }
    return isSaved;
  }

  void _showDialog(context, warning){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Align(
              alignment: Alignment.center,
              child: Text("Warning" ,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            content: Text(warning),
            actions: [
              TextButton(
                  onPressed: () {
                    // dismiss the alert dialog
                    Navigator.pop(context);
                  },
                  child: const Text("Close")),
            ],

          );
        });
  }
  // tn	String	The task name
  // frm	String	The user creating the task
  // to	String	The user assigned the task
  // date	String	The due date for the task
  Future<void> createNewExpense(String currUserId, String expenseName, List<dynamic> contributors, String dueDate, String amount) async {
    try {
      var reqBody = {
        "name": expenseName, // The user creating the task
        "price": double.parse(amount), // The task name
        "payer": currUserId, // The user assigned the task
        "contributors": contributors,
        "date": dueDate // The due date for the task
      };
      print(reqBody);
      var response = await http.post(
        Uri.parse(createExpensePth),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody), // Encode the request body as JSON
      );
      print(response.statusCode);
      print(response.body);
      await handlePost(response, responseType: 'createExpense');
      theme.buildToastMessage("Expense created successfully");
      //   kick back to the notification page
    } on UserException catch(e) {
      theme.buildToastMessage(e.message);
      rethrow;
    } on ExpenseException catch(e) {
      _showDialog(context, e.message);
      rethrow;
    }
  }
}
