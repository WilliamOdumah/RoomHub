import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/login/login.dart';
import 'package:flutter_frontend/widgets/button.dart';
import 'package:flutter_frontend/widgets/our_container.dart';
//import 'package:flutter_frontend/utils/comingsoon.dart';
import 'package:flutter_frontend/utils/our_theme.dart';
import 'package:flutter_frontend/screens/header.dart';

import 'package:flutter_frontend/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_frontend/aws_auth.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class OurHome extends ConsumerStatefulWidget {
  final String roomID;
  const OurHome({super.key, required this.roomID});

  @override
  ConsumerState<OurHome> createState() => _OurHomeState();
}

class _OurHomeState extends ConsumerState<OurHome> {
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
              padding: const EdgeInsets.only(left: 20, right: 20),
              physics:
                  const NeverScrollableScrollPhysics(), // Prevent scrolling
              shrinkWrap: true,
              children: <Widget>[
                //MY ROOM
                Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.darkblue,
                        theme.mintgreen,
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                      topRight: Radius.circular(80),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .start, // Keep text aligned to the start
                    children: [
                      const Text(
                        "My Room",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Visit ${widget.roomID}",
                        style: const TextStyle(
                          fontSize: 25.0,
                          color: Colors.white,
                        ),
                        softWrap: true,
                      ),
                      Center(
                        // Center the image and button
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/bed.png',
                              width: 200.0,
                              height: 170.0,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(
                                height: 10), // Space between image and button
                            MyButton(
                              text: "Continue",
                              onTap: () {
                                theme.buildToastMessage("coming soon");
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                //FIND ROOMMATES
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
                              MyButton(
                                  text: "Continue",
                                  onTap: () {
                                    theme.buildToastMessage("coming soon");
                                  })
                            ]),
                      ),
                      Expanded(
                        flex: 4,
                        child: Image.asset(
                            'assets/find_roommate.png'), //,width: 150.0, height: 150.0)
                      )
                    ],
                  ),
                ),

                ElevatedButton(
                  onPressed: () async {
                    logOut();
                  },
                  child: const Text(
                    "Log Out",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 8.0),
                  ),
                ),
              ],
            )
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
      ref.refresh(authUserProvider);

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const OurLogin()));
    } on AuthException catch (e) {
      theme.buildToastMessage(e.message);
    }
  }
}
