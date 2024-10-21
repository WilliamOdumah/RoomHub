// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_frontend/widgets/our_container.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_frontend/aws_auth.dart';
import 'package:flutter_frontend/providers.dart';
import 'package:flutter_frontend/utils/our_theme.dart';
import 'package:flutter_frontend/screens/home/home_new_user.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_frontend/config.dart';
import 'dart:convert';
import 'package:flutter_frontend/utils/custom_exceptions.dart';
import 'package:flutter_frontend/utils/response_handler.dart';

class Verification extends ConsumerStatefulWidget {
  final String email;
  const Verification({super.key, required this.email});
  @override
  _VerificationState createState() => _VerificationState();
}

// State class for OurLoginForm, managing state and widget lifecycle
class _VerificationState extends ConsumerState<Verification> {
  TextEditingController verifyController = TextEditingController();
  final theme = OurTheme();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Icon(Icons.menu, color: Theme.of(context).primaryColorDark),
        title: Text('RoomHub',
            style: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontSize: 25.0,
                fontWeight: FontWeight.bold)),
      ),
      body: OurContainer(
        child: Column(
          children: <Widget>[
            // Header for the login form
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
              child: Text("Enter Confirmation Code",
                  style: TextStyle(
                    color: Color.fromARGB(
                        255, 29, 52, 83), //Theme.of(context).primaryColorDark,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            // Text field for the email input
            TextFormField(
              controller: verifyController,
              cursorColor: Theme.of(context).primaryColorDark,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.numbers_outlined),
                hintText: "Verification Code",
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            // Login button to trigger sign-in operation
            ElevatedButton(
              onPressed: () async {
              if(await amplifyConfirmSignUp()){
                registerUserBE();
              }
            },
              child: const Text(
                "Verify",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
            ),
            const SizedBox(
              height: 25.0,
            ),

            
            // TextButton for navigating to the sign-up page
            TextButton(
              onPressed: () async {
                try {
                  // Accessing AWS authentication repository using Riverpod provider
                  final authAWSRepo = ref.read(authAWSRepositoryProvider);
                  // Attempting to sign in with email and password
                  await authAWSRepo.resendCode(widget.email);
                  // Refresh the auth user provider after signing in
                  ref.refresh(authUserProvider);
                  theme.buildToastMessage("verification code was resent");
                } on AuthException catch (e) {
                  theme.buildToastMessage(e.message);
                }
              },
              style: const ButtonStyle(
                tapTargetSize:
                    MaterialTapTargetSize.shrinkWrap, // Correct usage
              ),
              child: Text(
                'Resend Code',
                style: TextStyle(
                    color: theme.mintgreen,
                    decoration: TextDecoration.underline,
                    decorationColor: theme.mintgreen),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void registerUserBE() async {
    try {
    var regBody = {
      "id": widget.email,
    };
    var response = await http.post(
      Uri.parse(signup),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(regBody),
    );
      await handlePost(response, responseType: 'signup');
      ref.read(emailProvider.notifier).state = widget.email;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const OurHomeNewUser(),
        ),
      );
      
    } on UserException catch (e) {
      theme.buildToastMessage(e.message);
    }
  }

  Future<bool> amplifyConfirmSignUp() async {
    bool loginSuccess = false;
    try {
      // Accessing AWS authentication repository using Riverpod provider
      final authAWSRepo = ref.read(authAWSRepositoryProvider);
      // Attempting to sign in with email and password
      await authAWSRepo.confirmSignUp( widget.email,verifyController.text);
      // Refresh the auth user provider after signing in
      ref.refresh(authUserProvider);
      loginSuccess = true;
    } on AuthException catch (e) {
      theme.buildToastMessage(e.message);
    }
    return loginSuccess;
  }
}
