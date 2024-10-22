import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/signup/verification.dart';
import 'package:flutter_frontend/widgets/our_container.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_frontend/providers.dart';
import 'package:flutter_frontend/utils/our_theme.dart';
import 'package:flutter_frontend/aws_auth.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class SignUpForm extends ConsumerStatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

// State class for SignUpForm, managing state and widget lifecycle
class _SignUpFormState extends ConsumerState<SignUpForm> {
  // Controllers for form fields
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  
  // Theme object for consistent styling
  final theme = OurTheme();

  @override
  Widget build(BuildContext context) {
    return OurContainer(
      child: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
            child: Text("Sign Up",
                style: TextStyle(
                  color: Color.fromARGB(255, 29, 52, 83),
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                )),
          ),
          // Email input field
          TextFormField(
            controller: emailController,
            cursorColor: theme.darkblue,
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.alternate_email),
                label: Text(
                  "Email",
                  style: TextStyle(color: theme.darkblue),
                )),
          ),
          const SizedBox(height: 30.0),
          // Full Name input field
          TextFormField(
            cursorColor: theme.darkblue,
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person_outline),
                label: Text(
                  "Full Name",
                  style: TextStyle(color: theme.darkblue),
                )),
          ),
          const SizedBox(height: 30.0),
          // Password input field
          TextFormField(
            controller: passwordController,
            cursorColor: theme.darkblue,
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline),
                label: Text(
                  "Password",
                  style: TextStyle(color: theme.darkblue),
                )),
            obscureText: true, // Obscures the password input
          ),
          const SizedBox(height: 30.0),
          // Confirm Password input field
          TextFormField(
            controller: password2Controller,
            cursorColor: theme.darkblue,
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline),
                label: Text(
                  "Confirm Password",
                  style: TextStyle(color: theme.darkblue),
                )),
            obscureText: true, // Obscures the password input
          ),
          const SizedBox(height: 30.0),
          // Sign Up button
          ElevatedButton(
            child: const Text(
              "Sign Up",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
            onPressed: () {
              amplifySignUp(); // Calls the sign-up method
            },
          ),
          const SizedBox(height: 25.0),
        ],
      ),
    );
  }

  /// Validates if the confirm password matches the password
  void _validateConfirmPassword() {
    if (password2Controller.text != passwordController.text) {
      throw const InvalidPasswordException(
          "Password and Confirm Password don't match");
    }
  }

  /// Handles the sign-up process using AWS Amplify
  void amplifySignUp() async {
    try {
      _validateConfirmPassword(); // Validate password match

      final authAWSRepo = ref.read(authAWSRepositoryProvider);
      // Calls the sign-up method from the repository
      await authAWSRepo.signUp(emailController.text, passwordController.text);
      ref.refresh(authUserProvider); // Refresh the user provider
      // Navigate to the verification screen after successful sign-up
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Verification(email: emailController.text),
        ),
      );
    } on AuthException catch (e) {
      // Handle any authentication exceptions and show a message
      theme.buildToastMessage(e.message);
    }
  }
}
