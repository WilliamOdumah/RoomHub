import 'dart:convert';
import "package:flutter/material.dart";
import 'package:flutter_frontend/screens/userProfile/update_tags.dart';
import 'package:flutter_frontend/utils/our_theme.dart';
import "package:flutter_frontend/widgets/gradient_button.dart";
import 'package:http/http.dart' as http;
import 'package:flutter_frontend/utils/response_handler.dart';
import 'package:flutter_frontend/config.dart';

import '../../utils/custom_exceptions.dart';

class CreateProfile extends StatefulWidget {
  final String userId;
  const CreateProfile({super.key, required this.userId});

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final List<String> gender = ["Male", "Female", "Non-binary"];
  final List<String> ethnicity = [
    "Black",
    "Asian",
    "Caucasian / White",
    "Hispanic / Latino",
    "Middle Eastern",
    "Native American / Indigenous",
    "Pacific Islander",
    "Mixed / Multiple Ethnicities",
    "Other / Prefer Not to Say"
  ];
  final List<String> locations = [
    "Toronto", // Ontario
    "Montreal", // Quebec
    "Vancouver", // British Columbia
    "Calgary", // Alberta
    "Edmonton", // Alberta
    "Ottawa", // Ontario
    "Winnipeg", // Manitoba
    "Quebec City", // Quebec
    "Hamilton", // Ontario
    "Kitchener", // Ontario
    "Halifax", // Nova Scotia
    "Victoria", // British Columbia
    "Saskatoon", // Saskatchewan
    "Regina", // Saskatchewan
    "St. John's", // Newfoundland and Labrador
    "Sherbrooke", // Quebec
    "Barrie", // Ontario
    "Kelowna", // British Columbia
    "Abbotsford", // British Columbia
    "Trois-Rivières" // Quebec
  ];
  final List<String> contactType = ["Instagram", "Email", "Snapchat"];

  final theme = OurTheme();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  String? _selectedGender,
      _selectedLocation,
      _selectedContactType;
  DateTime? selectedDate;
  String? _nameError,
      _locationError,
      _genderError,
      _contactError,
      _contactTypeError,
      _bioError,
      _dateError;

  @override
  void initState() {
    super.initState();
  }

  bool isLoading = true;

  // date selection
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: OurTheme().darkblue, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: OurTheme().darkblue, // body text color
            ),
            dialogBackgroundColor: Colors.white, // background color
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        _dateController.text = _formatDate(pickedDate);
      });
    }
  }

  String _formatDate(DateTime date) {
    return "${date.toLocal()}".split(' ')[0];
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
          // Positioned header with back button and title
          Positioned(
            left: 20.0,
            right: 20.0,
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
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
                    heightFactor: 2.0,
                    child: Text(
                      'Create my profile',
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
                padding: const EdgeInsets.only(left: 23.0, right: 23.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 40.0,
                      ),
                      // N A M E
                      TextFormField(
                        controller: _nameController,
                        cursorColor: theme.darkblue,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.person_outline),
                            label: Text(
                              "Name",
                              style: TextStyle(color: theme.darkblue),
                            ),
                            errorText: _nameError),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      //L O C A T I O N
                      DropdownButtonFormField<String>(
                        menuMaxHeight: 450,
                        value: _selectedLocation,
                          icon: const Icon(Icons.arrow_drop_down),
                          decoration: InputDecoration(
                              label: Text(
                                "Location",
                                style: TextStyle(color: theme.darkblue),
                              ),
                              errorText: _locationError),
                          dropdownColor: Colors
                              .white, // Background color of dropdown items
                          style: TextStyle(color: theme.darkblue),
                          items: locations
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedLocation = newValue;
                            });
                          }),
                      
                      const SizedBox(
                        height: 20.0,
                      ),
                      // B I R T H  D A T E
                      TextFormField(
                        controller: _dateController,
                        cursorColor: theme.darkblue,
                        readOnly: true,
                        onTap: () =>
                            _selectDate(context), // Show date picker on tap
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.calendar_today),
                          label: Text(
                            "Birth date",
                            style: TextStyle(color: theme.darkblue),
                          ),
                          errorText: _dateError,
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      //G E N D E R
                      DropdownButtonFormField<String>(
                          value: _selectedGender,
                          icon: const Icon(Icons.arrow_drop_down),
                          decoration: InputDecoration(
                              label: Text(
                                "Gender",
                                style: TextStyle(color: theme.darkblue),
                              ),
                              errorText: _genderError),
                          dropdownColor: Colors
                              .white, // Background color of dropdown items
                          style: TextStyle(color: theme.darkblue),
                          items: gender
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedGender = newValue;
                            });
                          }),
                      const SizedBox(
                        height: 20.0,
                      ),
                      // C O N T A C T
                      DropdownButtonFormField<String>(
                          value: _selectedContactType,
                          icon: const Icon(Icons.arrow_drop_down),
                          decoration: InputDecoration(
                              label: Text(
                                "Contact Type",
                                style: TextStyle(color: theme.darkblue),
                              ),
                              errorText: _contactTypeError),
                          dropdownColor: Colors
                              .white, // Background color of dropdown items
                          style: TextStyle(color: theme.darkblue),
                          items: contactType
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedContactType = newValue;
                            });
                          }),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: _contactController,
                        cursorColor: theme.darkblue,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.person_outline),
                            label: Text(
                              "Contact",
                              style: TextStyle(color: theme.darkblue),
                            ),
                            errorText: _contactError),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      //D E S C R I P T I O N
                      // Adjust the height as needed
                      TextFormField(
                        controller: _descriptionController,
                        cursorColor: theme.darkblue,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.person_outline),
                            label: Text(
                              "Description",
                              style: TextStyle(color: theme.darkblue),
                            ),
                            hintText:
                                "Use this space for what would you like people to know about you!", // Adding hint text
                            hintStyle: const TextStyle(
                                color: Colors
                                    .grey), // Customize hint text color if needed
                            errorText: _bioError,
                            floatingLabelBehavior:
                                FloatingLabelBehavior.always),
                        maxLines:
                            null, // Allows the text field to expand vertically with content
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      //S A V E    B U T T O N
                      GradientButton(
                          text: 'Continue',
                          onTap: () async {
                            bool isSaved = await saveChanges(context);
                            if (isSaved) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TagForm(userId: widget.userId),
                                ),
                              );
                            }
                          }),
                          const SizedBox(
                        height: 50.0,
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
      // Check if any field is empty
      _nameError =
          _nameController.text.isEmpty ? 'This field is required' : null;
      _genderError = _selectedGender == null ? 'This field is required' : null;
      _contactError =
          _contactController.text.isEmpty ? 'This field is required' : null;
      _contactTypeError =
          _selectedContactType == null ? 'This field is required' : null;
      _locationError =
          _selectedLocation == null ? 'This field is required' : null;
      _dateError =
          _dateController.text.isEmpty ? 'This field is required' : null;
      _bioError =
          _descriptionController.text.isEmpty ? 'This field is required' : null;
    });

    // If fields are valid, you can proceed with your logic
    if (_nameError == null &&
        _genderError == null &&
        _locationError == null &&
        _contactError == null &&
        _contactTypeError == null &&
        _dateError == null &&
        _bioError == null) {
      print('Form is valid');
      return true;
    } else {
      return false;
    }
  }

  Future<bool> saveChanges(BuildContext context) async {
    bool isSaved = false;
    try {
      if (_validateFields()) {
        await createProfile(
            widget.userId,
            _selectedLocation,
            _nameController,
            _selectedGender,
            _dateController,
            _descriptionController,
            _selectedContactType,
            _contactController);
        isSaved = true;
      }
    } catch (e) {
      theme.buildToastMessage("Something went wrong. Please try again later");
      isSaved = false;
    }
    return isSaved;
  }

  Future<void> createProfile(
      String userId,
      String? location,
      TextEditingController name,
      String? gender,
      TextEditingController dob,
      TextEditingController bio,
      String? contactType,
      TextEditingController contact) async {
    try {
      var reqBody = {
      "location": location,
      "name": name.text,
      "gender": gender,
      "dob": dob.text,
      "bio": bio.text,
      "contact_type": contactType,
      "contact": contact.text,
    };
      print(reqBody);
      var response = await http.post(
        Uri.parse("$profile/$userId/$createProfilePth"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody), // Encode the request body as JSON
      );
      print(response.statusCode);
      print(response.body);
      await handlePost(response, responseType: 'createProfile');
      theme.buildToastMessage("Profile created successfully");
    } on ProfileException catch (e) {
      theme.buildToastMessage(e.message);
      rethrow;
    }
  }
}
