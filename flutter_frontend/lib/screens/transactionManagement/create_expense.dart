
import 'dart:convert';

import "package:flutter/material.dart";
import 'package:flutter_frontend/screens/taskManagement/all_task.dart';
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
  const ExpenseForm({super.key, required this.email, required this.roomId});

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final theme = OurTheme();
  TextEditingController _taskNameController = TextEditingController();
  String? selectedRoommate;
  // final List<String> roomMates= ["danny@gmail.com","dd@gmail.com", "lola@gmail.com"];
  DateTime? selectedDate;
  TextEditingController _dateController = TextEditingController();

  String? _taskNameError; // Error message for task name field
  String? _dateError;       // Error message for date field
  String? _contributorError; //Error message for the list of contributors.

  List<dynamic> contributors = [];
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

    for(String roommate in all_roommates){
      if(roommate != widget.email){
        contributors.add(roommate);
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
        List<dynamic> roommates = jsonData['roommates'];
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
    print(_contributorError);
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
            child: Padding(
              padding: EdgeInsets.only(top: 50),
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
                      'Transaction\n Management',
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
                        controller: _taskNameController,
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
                      MultiSelectFormField(options: contributors, errorState: _contributorError,updateChoices: updateContributors, hint: 'Contributors',),
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
                            bool isSaved = await saveTask(context);
                            if(isSaved){
                              String announcementMsg = generateAnnouncementMsg(selectedRoommate!,_taskNameController.text);
                              sendAnnouncementRequest(announcementMsg, widget.email);
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => AllTasks(email: widget.email, roomId: widget.roomId,),
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
      _taskNameError = _taskNameController.text.isEmpty ? 'This field is required' : null;
      // Check if the email field is empty
      _dateError = _dateController.text.isEmpty ? 'This field is required' : null;
      _contributorError = contributors.isEmpty ? 'This field is required. Select at least 1 contributor' : null;
      print(contributors.isEmpty);
      print(_contributorError);
    });

    // If all fields are valid, proceed
    if (_taskNameError == null && _contributorError == null && _dateError == null) {
      // Proceed with form submission
      print('Form is valid');
      // You can add your submission logic here
      return true;
    }
    else{
      return false;
    }
  }

  Future<bool> saveTask(BuildContext context) async{
    bool isSaved = false;
    try{
      if(_validateFields()){
        debugPrint("Add backend stuff to create a new task");
        await createNewTask(widget.email, _taskNameController.text, selectedRoommate!, _dateController.text);
        isSaved = true;
      }
    } catch (e){
      theme.buildToastMessage("Something went wrong. Please try again later");
      isSaved = false;
    }
    return isSaved;
  }

  String generateAnnouncementMsg(String user, String task){
    return 'The task "$task" has been assigned to $user';
  }

  // tn	String	The task name
  // frm	String	The user creating the task
  // to	String	The user assigned the task
  // date	String	The due date for the task
  Future<void> createNewTask(String currUserId, String taskName, String assignedTo, String dueDate) async {
    try {
      var reqBody = {
        "frm": currUserId, // The user creating the task
        "tn": taskName, // The task name
        "to": assignedTo, // The user assigned the task
        "date": dueDate // The due date for the task
      };
      print(reqBody);
      var response = await http.post(
        Uri.parse(createTaskPth),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody), // Encode the request body as JSON
      );
      await handlePost(response, responseType: 'createTask');
      theme.buildToastMessage("Task created successfully");
      //   kick back to the notification page
    } on UserException catch(e) {
      theme.buildToastMessage(e.message);
      rethrow;
    }
  }

  void sendAnnouncementRequest(String announcement, String sender) async {
    try {
      var reqBody = {
        "from": sender, // User's email (sender)
        "message": announcement, // New announcement.
        "type": 'announcement', // Request type
      };
      var response = await http.post(
        Uri.parse(sendAnnouncementPth),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody), // Encode the request body as JSON
      );
      await handlePost(response, responseType: 'sendAnnouncement');
      theme.buildToastMessage("Announcement sent successfully");
    } on NotificationException catch(e) {
      theme.buildToastMessage(e.message);
    }
  }
}
