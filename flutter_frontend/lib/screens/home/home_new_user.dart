
import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/createRoom/create_room.dart';
import 'package:flutter_frontend/screens/header.dart';
import 'package:flutter_frontend/screens/joinRoom/join_room.dart';
import 'package:flutter_frontend/utils/our_theme.dart';
import 'package:flutter_frontend/widgets/gradient_button.dart';
import 'package:flutter_frontend/widgets/our_container.dart';
//import 'package:flutter_frontend/utils/comingsoon.dart';
import 'package:flutter_frontend/screens/login/login.dart';

import 'package:flutter_frontend/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_frontend/aws_auth.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class OurHomeNewUser extends ConsumerStatefulWidget {
  const OurHomeNewUser({super.key});

  @override
  ConsumerState<OurHomeNewUser> createState() => _OurHomeNewUserState();
}

class _OurHomeNewUserState extends ConsumerState<OurHomeNewUser> {
  final theme = OurTheme();

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey[300],
    body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const Header(),
          ListView(
            padding: const EdgeInsets.only(
                top: 10.0, right: 20, left: 20, bottom: 20),
            physics: const NeverScrollableScrollPhysics(), // Prevent scrolling
            shrinkWrap: true, // Allow it to take only the needed space
            children: <Widget>[
              // CREATE ROOM CONTAINER
              OurContainer(
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text("Create a Room",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 29, 52, 83),
                                  fontSize: 23.0,
                                  fontWeight: FontWeight.bold)),
                          const Text('If this is your first time in the app',
                              softWrap: true),
                          const SizedBox(height: 10),
                          GradientButton(
                              text: "Continue",
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const CreateRoom(),
                                ));
                              })
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Image.asset('assets/bed.png'),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // JOIN ROOM
              OurContainer(
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text("Join a Room",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 29, 52, 83),
                                  fontSize: 23.0,
                                  fontWeight: FontWeight.bold)),
                          const Text(
                              'If the room has already been created by your roommates',
                              softWrap: true),
                          const SizedBox(height: 10),
                          GradientButton(
                              text: "Continue",
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const JoinRoom(),
                                ));
                              })
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Image.asset('assets/find_room.png'),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // FIND ROOMMATES
              OurContainer(
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text("Find Roommates",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 29, 52, 83),
                                  fontSize: 23.0,
                                  fontWeight: FontWeight.bold)),
                          const Text(
                              'If you are looking for your perfect match',
                              softWrap: true),
                          const SizedBox(height: 10),
                          GradientButton(
                              text: "Continue",
                              onTap: () {
                               theme.buildToastMessage("coming soon");
                              })
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Image.asset('assets/find_roommate.png'),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  logOut();
                },
                child: const Text(
                  "Log Out",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 7.0),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}


  void logOut() async {
    try {
      // Accessing AWS authentication repository using Riverpod provider
      final authAWSRepo = ref.read(authAWSRepositoryProvider);
      // Attempting to sign in with email and password
      await authAWSRepo.logOut(ref);
      // Refresh the auth user provider after signing in
      // ignore: unused_result
      ref.refresh(authUserProvider);
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) =>
                const OurLogin()));
    } on AuthException catch (e) {
      theme.buildToastMessage(e.message);
    }
  }
}
