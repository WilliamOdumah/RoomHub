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

// State class for OurLoginForm, managing state and widget lifecycle
class _SignUpFormState extends ConsumerState<SignUpForm> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  final theme = OurTheme();
// State variable for error message

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
          const SizedBox(
            height: 30.0,
          ),
          TextFormField(
            cursorColor: theme.darkblue,
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person_outline),
                label: Text(
                  "Full Name",
                  style: TextStyle(color: theme.darkblue),
                )),
          ),
          const SizedBox(
            height: 30.0,
          ),
          TextFormField(
            controller: passwordController,
            cursorColor: theme.darkblue,
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline),
                label: Text(
                  " Password",
                  style: TextStyle(color: theme.darkblue),
                )),
            obscureText: true,
          ),
          const SizedBox(
            height: 30.0,
          ),
          TextFormField(
            controller: password2Controller,
            cursorColor: theme.darkblue,
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline),
                label: Text(
                  "Confirm Password",
                  style: TextStyle(color: theme.darkblue),
                )),
            obscureText: true,
          ),
          const SizedBox(
            height: 30.0,
          ),
          ElevatedButton(
              child: const Text(
                "Sign Up",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
              onPressed: () {
                amplifySignUp();
              }),
          const SizedBox(
            height: 25.0,
          ),
        ],
      ),
    );
  }

  /// Validate if the confirm password matches the password
  void _validateConfirmPassword() {
    if (password2Controller.text != passwordController.text) {
      throw const InvalidPasswordException(
          "Password and Confirm Password don't match");
    }
  }

  void amplifySignUp() async {
    try {
      _validateConfirmPassword();

      final authAWSRepo = ref.read(authAWSRepositoryProvider);
      await authAWSRepo.signUp(emailController.text, passwordController.text);
      ref.refresh(authUserProvider);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Verification(email: emailController.text),
        ),
      );
    } on AuthException catch (e) {
      theme.buildToastMessage(e.message);
    }
  }
}
