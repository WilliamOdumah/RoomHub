import 'dart:async';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

/// A provider for the AWS Authentication Repository, allowing access to authentication methods.
final authAWSRepositoryProvider =
    Provider<AWSAuthRepository>((ref) => AWSAuthRepository());

class AWSAuthRepository {

  Future<Map<String, String>> getUserAttributes() async {
    // Get the current user
    
    // Fetch the user attributes
    final attributes = await Amplify.Auth.fetchUserAttributes();
    
    // Convert attributes to a map with string keys
    return {for (var attr in attributes) attr.userAttributeKey.toString(): attr.value};
  }



  /// A getter that returns the current user's ID as a [String].
  ///
  /// This method retrieves the currently authenticated user from AWS Amplify.
  /// If there is no signed-in user, it returns null.
  Future<String?> get user async {
    try {
      final awsUser = await Amplify.Auth.getCurrentUser();
      return awsUser.userId; // Return the user's ID
    } catch (e) {
      // Uncomment the line below for debugging purposes
      // print("not signed in");
      return null; // Return null if no user is signed in
    }
  }

   

  /// Signs up a new user with the provided [email] and [password].
  ///
  /// This method creates a new account in AWS Cognito using the specified email
  /// and password. It also sets the user's email as an attribute in Cognito.
  ///
  /// Throws an exception if the sign-up fails.
  Future<void> signUp(String email, String password) async {
    try {
      final userAttributes = <AuthUserAttributeKey, String>{
        AuthUserAttributeKey.email: email, // Set the user's email attribute
      };
      await Amplify.Auth.signUp(
          username: email,
          password: password,
          options: SignUpOptions(userAttributes: userAttributes));
    } on Exception {
      rethrow; // Rethrow the exception for handling in the UI layer
    }
  }

  /// Confirms the sign-up of a new user with the provided [email] and [confirmationCode].
  ///
  /// This method is used to verify the user's email address after they sign up.
  /// It sends the confirmation code provided by the user to AWS Cognito.
  ///
  /// Throws an exception if the confirmation fails.
  Future<void> confirmSignUp(String email, String confirmationCode) async {
    try {
      await Amplify.Auth.confirmSignUp(
          username: email, confirmationCode: confirmationCode);
    } on Exception {
      rethrow; // Rethrow the exception for handling in the UI layer
    }
  }

  Future<void> resendCode(String email) async {
    try {
      await Amplify.Auth.resendSignUpCode(username: email);
    } on Exception {
      rethrow; // Rethrow the exception for handling in the UI layer
    }
  }

  /// Signs in an existing user with the provided [email] and [password].
  ///
  /// This method authenticates the user with AWS Cognito using the provided credentials.
  /// If the sign-in is successful, the user will be logged in.
  ///
  /// Throws an exception if the sign-in fails.
  Future<void> signIn(String email, String password) async {
    try {
      await Amplify.Auth.signIn(username: email, password: password);
    } on Exception {
      rethrow; // Rethrow the exception for handling in the UI layer
    }
  }

  /// Logs out the current user.
  ///
  /// This method signs out the currently authenticated user, which will trigger
  /// the user stream to emit [User.empty].
  ///
  /// Throws an exception if the sign-out fails.
  Future<void> logOut(WidgetRef ref) async {
    try {
      await Amplify.Auth.signOut();
      ref.read(emailProvider.notifier).state = ''; // Check if the widget is still mounted before navigating

    } on Exception {
      rethrow; // Rethrow the exception for handling in the UI layer
    }
  }

  Future<String?> getUserEmail(WidgetRef ref) async {
  try {
    // Fetch user attributes like email
    List<AuthUserAttribute> attributes = await Amplify.Auth.fetchUserAttributes();

    // Extract email
    String? email;
    for (var attribute in attributes) {
      if (attribute.userAttributeKey == CognitoUserAttributeKey.email) {
        email = attribute.value;
        break;
      }
    }

    if (email != null) {
      // Store the email in the provider
      ref.read(emailProvider.notifier).state = email;
      return email; // Return the email
    } else {
      print("Email not found for the user");
      return null; // Return null if the email is not found
    }
  } catch (e) {
    print("Error retrieving user email: $e");
    return null; // Return null in case of an error
  }
}




}
