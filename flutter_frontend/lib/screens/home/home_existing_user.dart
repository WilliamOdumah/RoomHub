import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/room_page.dart';
import 'package:flutter_frontend/screens/login/login.dart';
import 'package:flutter_frontend/widgets/button.dart';
import 'package:flutter_frontend/widgets/header_profile.dart';
import 'package:flutter_frontend/widgets/our_container.dart';
//import 'package:flutter_frontend/utils/comingsoon.dart';
import 'package:flutter_frontend/utils/our_theme.dart';
import 'package:flutter_frontend/widgets/header.dart';

import 'package:flutter_frontend/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_frontend/aws_auth.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

import '../../utils/custom_exceptions.dart';
import '../findRoommate/find_roommate_main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_frontend/config.dart';

class OurHomeExisting extends ConsumerStatefulWidget {
  final String roomID;
  final String email;
  final Future<void> Function()? onRefresh;
  const OurHomeExisting({super.key, required this.roomID, required this.email, required this.onRefresh});

  @override
  ConsumerState<OurHomeExisting> createState() => _OurHomeExistingState();
}

class _OurHomeExistingState extends ConsumerState<OurHomeExisting> {
  final theme = OurTheme();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: RefreshIndicator(
        onRefresh: widget.onRefresh!,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: <Widget>[
              const HeaderProfile(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
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
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => UserRoom(roomID:widget.roomID, email: widget.email),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              //FIND ROOMMATES
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: OurContainer(
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
                                  onTap: () async {
                                    bool hasProf = await hasProfile(widget.email);
                                    print(hasProf);
                                    if (hasProf) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => FindRoommateMain(),
                                        ),
                                      );
                                    } else {
                                      theme.buildToastMessage(
                                          "Create your profile by clicking the user icon at the top left");
                                    }
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
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.all(18.0),
                child: ElevatedButton(
                  onPressed: () async {
                    logOut();
                  },
                  child: const Text(
                    "Log Out",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  Future<bool> hasProfile(String userId) async {
    bool hasProfile = false;
    try {
      var response = await http.get(
        Uri.parse("$user/$userId/$findRoomMatePage"),
        headers: {"Content-Type": "application/json"},
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        hasProfile = true;
      }
    } on ProfileException catch (e) {
      print(e.toString());
      return false;
    }
    return hasProfile;
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
