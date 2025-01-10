
import 'dart:convert';

import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_frontend/utils/our_theme.dart';
import "package:flutter_frontend/widgets/gradient_button.dart";
import 'package:http/http.dart' as http;
import 'package:flutter_frontend/utils/response_handler.dart';
import 'package:flutter_frontend/config.dart';

import '../../utils/custom_exceptions.dart';
import 'all_transactions.dart';


class SettleUp extends StatefulWidget {
  final String email;
  final String roomId;
  final Map<String, dynamic> summaryData;
  const SettleUp({super.key, required this.email, required this.roomId, required this.summaryData});

  @override
  State<SettleUp> createState() => _SettleUpState();
}

class _SettleUpState extends State<SettleUp> {
  final theme = OurTheme();
  TextEditingController _amountController = TextEditingController();
  String? selectedRoommate;

  DateTime? selectedDate;
  TextEditingController _dateController = TextEditingController();

  String? _amountError; // Error message for task name field
  String? _assigneeError; // Error message for assignee field
  String? _dateError;       // Error message for date field

  bool isLoading = true; // Track loading state
  List<dynamic> payers = [];

  @override
  void initState() {
    super.initState();
    getRoommatesCaller();
  }


  Future<void> getRoommatesCaller() async {
    //API request or some async operation
    List<dynamic> all_roommates = await getRoommates();

    // update done here roommates = [[id, name], []]
    // for(String roommate in all_roommates){
    //   if(roommate != widget.email){
    //     payers.add(roommate);
    //   }
    // }
    // all_roommates = [["dan@gmail.com","daniel"],["dolo@gmail.com","Dolo"],["kola@gmail.com","kola"]];
    for(dynamic roommate in all_roommates){
      if(roommate[0] != widget.email){
        payers.add(roommate);
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
                      '\nTransaction \nManagement',
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
                        child: Text("Settle Up",
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
                        controller: _amountController,
                        cursorColor: theme.darkblue,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), // Allows digits and a single decimal point
                        ],
                        decoration: InputDecoration(
                            label: Text(
                              "Amount(CAD)",
                              style: TextStyle(color: theme.darkblue),
                            ),
                            errorText: _amountError
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      DropdownButtonFormField<String>(
                          value: selectedRoommate,
                          icon: const Icon(Icons.arrow_drop_down),
                          decoration: InputDecoration(
                              label: payers.isEmpty ?
                              Text(
                                "No roommates",
                                style: TextStyle(color: theme.darkblue),
                              ) :
                              Text(
                                "Settled By(payer)",
                                style: TextStyle(color: theme.darkblue),
                              ),
                              errorText: _assigneeError
                          ),
                          items: payers.map<DropdownMenuItem<String>>((dynamic value) {
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
                            "Date",
                            style: TextStyle(color: theme.darkblue),
                          ),
                          errorText: _dateError,
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      GradientButton(text: 'Settle',
                          onTap: () async{
                            bool isSaved = await settleDebt(context);
                            if(isSaved){
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => SharedExpensesPage(userId:widget.email, roomId: widget.roomId, 
                                  ),
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
      _amountError = _amountController.text.isEmpty ? 'This field is required' : null;
      // Check if the email field is empty
      _assigneeError = selectedRoommate == null ? 'This field is required' : null;
      _dateError = _dateController.text.isEmpty ? 'This field is required' : null;
    });

    // If both fields are valid, you can proceed with your logic
    if (_amountError == null && _assigneeError == null && _dateError == null) {
      // Proceed with form submission
      print('Form is valid');
      // You can add your submission logic here
      return true;
    }
    else{
      return false;
    }
  }

  Future<bool> settleDebt(BuildContext context) async{
    bool isSaved = false;
    try{
      if(_validateFields()){
        debugPrint("Add backend stuff to create a new task");
        await createSettleUpTransaction(widget.email, selectedRoommate!, _amountController.text, _dateController.text);
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

  Future<void> createSettleUpTransaction(String creditor, String debtor, String amount, String dueDate) async {
    try {
      var reqBody = {
        "creditor": creditor, // The person owed money
        "amount": double.parse(amount), // The amount paid back
        "debtor": debtor, // The user paying back
        "date": dueDate // The date the payment was made
      };
      var response = await http.post(
        Uri.parse(settleUpPth),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody), // Encode the request body as JSON
      );
      print(response.statusCode);
      print(response.body);
      await handlePost(response, responseType: 'createSettleUpTransaction');
      theme.buildToastMessage("Transaction created successfully");
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
