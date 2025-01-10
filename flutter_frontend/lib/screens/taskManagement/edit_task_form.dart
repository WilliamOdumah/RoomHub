
import 'dart:convert';

import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_frontend/utils/our_theme.dart';
import "package:flutter_frontend/widgets/gradient_button.dart";
import 'package:http/http.dart' as http;
import 'package:flutter_frontend/utils/response_handler.dart';
import 'package:flutter_frontend/config.dart';

import '../../utils/custom_exceptions.dart';
import 'all_task.dart';


class EditTaskForm extends StatefulWidget {
  final String taskName;
  final String assignedTo;
  // not all tasks have due dates.
  final String dueDate;
  final String taskId;
  final String loggedInUser;
  final String roomId;
  const EditTaskForm({super.key, required this.taskName, required this.assignedTo, required this.taskId, required this.dueDate,required this.loggedInUser , required this.roomId});

  @override
  State<EditTaskForm> createState() => _EditTaskFormState();
}

class _EditTaskFormState extends State<EditTaskForm> {
  final theme = OurTheme();
  TextEditingController _taskNameController = TextEditingController();
  DateTime? selectedDate;
  TextEditingController _dateController = TextEditingController();
  String? selectedRoommate;
  List<dynamic> roomMates  = [];
  String? _taskNameError; // Error message for name field
  String? _assigneeError; // Error message for email field
  String? _dueDateError; //Error message for due date
  bool isLoading = true; // Track loading state


  @override
  void initState() {
    super.initState();
    // Add listener to the TextField controller
    debugPrint(widget.taskId);
    _taskNameController.text = widget.taskName;
    _dateController.text = widget.dueDate;
    getRoommatesCaller();
    }

  Future<void> getRoommatesCaller() async {
    // Simulate an API request or some async operation
    roomMates = await getRoommates();
    // Update the loading state and rebuild the UI
    setState(() {
      isLoading = false; // Update loading state
      // choose selected roommate after roommate has been selected
      // selectedRoommate = widget.assignedTo;
    });
  }

  Future<List<dynamic>> getRoommates() async {
    List<dynamic> result = [];
    print(widget.loggedInUser);
    try {
      var response = await http.get(
        Uri.parse("$user/${widget.loggedInUser}/$getRoommatesList"),
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
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        _dateController.text = "${pickedDate.toLocal()}".split(' ')[0]; // Formatting date
        debugPrint(_dateController.text);
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
                      '\nTask\nManagement',
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
          ),Padding(
            padding: const EdgeInsets.only(top: 150.0),
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
                        child: Text("Edit a Task",
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
                              "Task Name",
                              style: TextStyle(color: theme.darkblue),
                            ),
                            errorText: _taskNameError
                        ),
                        maxLength: 30,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(50), // Limits input to 50 characters
                        ],
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      DropdownButtonFormField<String>(
                          value: selectedRoommate,
                          icon: const Icon(Icons.arrow_drop_down),
                          decoration: InputDecoration(
                              label: Text(
                                "Choose Roommate",
                                style: TextStyle(color: theme.darkblue),
                              ),
                              errorText: _assigneeError
                          ),
                          items: roomMates.map<DropdownMenuItem<String>>((dynamic value) {
                            return DropdownMenuItem<String>(value: value[0], child: Text(value[1]));
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedRoommate = newValue;
                            });
                          }
                      ),
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
                            "Due date",
                            style: TextStyle(color: theme.darkblue),
                          ),
                          errorText: _dueDateError
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      GradientButton(text: 'Save Task',
                          onTap: () async {
                              bool taskSaved = await saveTask();
                              if(taskSaved){
                                String announcementMsg = generateAnnouncementMsg(selectedRoommate!,_taskNameController.text);
                                sendAnnouncementRequest(announcementMsg, widget.loggedInUser);
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => AllTasks(email: widget.loggedInUser, roomId: widget.roomId,),
                                  ),
                                );
                              }
                            }
                          ),
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
      _assigneeError = selectedRoommate == null ? 'This field is required' : null;
    //   check that the due date is at least >= today
      debugPrint(_dateController.text);
      DateTime parsedDueDate = DateTime.parse(_dateController.text);
      print(parsedDueDate.isBefore(DateTime.now()));
      _dueDateError = parsedDueDate.isBefore(DateTime.now()) ? 'Due date cannot be in the past' : null;
    });

    print(_taskNameError);
    print(_assigneeError);
    print(_dueDateError);
    // If three fields are valid, you can proceed with your logic
    if (_taskNameError == null && _assigneeError == null && _dueDateError == null) {
      // Proceed with form submission
      print('Form is valid');
      // You can add your submission logic here
      return true;
    }
    else{
      return false;
    }
  }

  String generateAnnouncementMsg(String user, String task){
    String username = "";
    for(dynamic roomMember in roomMates){
      if(roomMember[0] == user){
        username = roomMember[1] as String;
        break;
      }
    }
    print("send msg");
    return 'The task "$task" has been assigned to $username';
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

  Future<void> editTask(String currUserId, String taskName, String assignedTo, String dueDate, String taskId) async {
    try {
      var reqBody = {
        "id" : taskId,
        "frm": currUserId, // The user creating the task
        "tn": taskName, // The task name
        "to": assignedTo, // The user assigned the task
        "date": dueDate // The due date for the task
      };
      print(reqBody);
      var response = await http.post(
        Uri.parse(editTaskPth),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody), // Encode the request body as JSON
      );
      print(response.statusCode);
      print(response.body);
      await handlePost(response, responseType: 'editTask');
      theme.buildToastMessage("Task created successfully");
      //   kick back to the notification page
    } on UserException catch(e) {
      theme.buildToastMessage(e.message);
      rethrow;
    } on RoomException catch(e) {
      theme.buildToastMessage(e.message);
      rethrow;
    } on TaskException catch(e) {
      theme.buildToastMessage(e.message);
      rethrow;
    }
  }

  Future<bool> saveTask() async {
    // widget.loggedInUser, _taskNameController.text, selectedRoommate!,_dateController.text,widget.taskId
    bool isSaved = false;
    try{
      if(_validateFields()){
        debugPrint("Add backend stuff to save an existing task");
        await editTask(widget.loggedInUser, _taskNameController.text,  selectedRoommate!, _dateController.text, widget.taskId);
        isSaved = true;
      }
    } catch(e){
      theme.buildToastMessage("Request could not be completed. Try again later.");
    }
    return isSaved;
  }

  bool isValidAnnouncement(String msg) {
    return msg.isNotEmpty; // Returns true if msg is not empty, false otherwise
  }
}


// I forgot my keys—can someone let me in?"
// "I'm having friends over tonight, just a heads-up."
// "I’ll be late coming home, don’t wait up!"
// "The Wi-Fi’s down—anyone else having issues?"
// "Left the stove on—could someone check?"
// "Package is arriving today, could someone grab it?"
// "Cleaning day tomorrow—let's remember to tidy up!"