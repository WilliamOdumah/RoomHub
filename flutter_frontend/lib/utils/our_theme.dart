import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// Class to define and build the app's theme and toasts
class OurTheme {
  // Custom colors used throughout the app
  final Color yellow = const Color.fromARGB(255, 253, 193, 87);
  final Color mintgreen = const Color.fromARGB(255, 139, 191, 187);
  final Color darkblue = const Color.fromARGB(255, 29, 52, 83);
  final Color lightgrey = const Color.fromARGB(255, 213, 213, 206);
  final Color darkgrey = const Color.fromARGB(255, 89, 89, 94);

  // Method to build and return the app's theme
  ThemeData buildTheme() {
    return ThemeData(
        canvasColor: lightgrey,
        primaryColor: mintgreen,
        primaryColorDark: darkblue,
        primaryColorLight: yellow,
        secondaryHeaderColor: darkgrey,
        // Hint color for text fields or placeholders
        hintColor: lightgrey,

        // Input decoration theme for customizing text fields
        inputDecorationTheme: InputDecorationTheme(
            // Default border style for text fields
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: lightgrey, width: 1.0)),
            // Border style when the text field is focused
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: darkblue, width: 2.0),
            )),

        // Theme for ElevatedButton widget styling
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(darkblue),
            padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 100.0, vertical: 12.0)),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0))),
          ),
        ),

        // Button styling for button types
        buttonTheme: ButtonThemeData(
          buttonColor: darkblue, // Button color
          padding:
              const EdgeInsets.symmetric(horizontal: 100.0, vertical: 12.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),

        // Text styles for headlines and other text elements
        textTheme: TextTheme(
          // Large headline text style (e.g., titles)
          headlineLarge: TextStyle(
            fontSize: 32, // Example size for large headline
            fontWeight: FontWeight.bold,
            color: darkblue, // Main color for large headline
          ),
          // Medium headline text style (e.g., section headers)
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: darkblue,
          ),
        ));
  }

  // Method to display a toast message using FlutterToast
  void buildToastMessage(String text) {
    Fluttertoast.showToast(
        msg: text, 
        timeInSecForIosWeb: 2, 
        toastLength: Toast.LENGTH_SHORT, 
        gravity: ToastGravity.BOTTOM, // Position of the toast
        backgroundColor: darkgrey, 
        textColor: Colors.white,
        fontSize: 14); 
  }
}
