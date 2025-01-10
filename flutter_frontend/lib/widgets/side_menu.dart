
import "package:flutter/material.dart";
import "package:flutter_frontend/screens/createAnnouncement/create_announcement_page.dart";
import 'package:flutter_frontend/screens/home/home_new_user.dart';
import 'package:flutter_frontend/screens/home/user_home.dart';
import 'package:flutter_frontend/screens/reviewRoommate/review_roommate.dart';
import 'package:flutter_frontend/utils/custom_exceptions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_frontend/utils/response_handler.dart';
import 'package:flutter_frontend/config.dart';
import 'package:flutter_frontend/utils/our_theme.dart';

import 'package:flutter_frontend/aws_auth.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_frontend/providers.dart';

import '../screens/login/login.dart';

class Navbar extends ConsumerWidget {
  final String roomId;
  final String email;
  const Navbar({super.key, required this.roomId, required this.email});

  void _showDialog(context, leaveRoomWarning){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Align(
              alignment: Alignment.center,
              child: Text("Leave Room" ,
                    style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
              ),
                        ),
            ),
            content: Text(leaveRoomWarning),            // this should be gen from api call
            actions: [
              TextButton(
                onPressed: () {print("Go ahead with the leave");leaveRoom(context);},//tell the backend to do stuff.
                child: const Text("Leave")),
              TextButton(
                onPressed: () {
                  // dismiss the alert dialog
                  Navigator.pop(context);
                  },
                child: const Text("Cancel")),
            ],

          );
        });
  }
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    String imagePath = "assets/logo.png";
    final theme = OurTheme();
    return Drawer(
      child: ListView(
        children:[
          Container(
          // room hub logo
            width: double.infinity, // Take up full width of the drawer
            height: MediaQuery.of(context).size.height * 0.25,  // 30% of the screen height
            margin: EdgeInsets.only(top: 30.0,),
             child: Image.asset(
              imagePath,  // Load the local image
              fit: BoxFit.contain,  // Make the image cover the full container
            ),
          ),

          ListTile(
            // room name
            title: Align(
                alignment: Alignment.center,
                child: Text(roomId,
                        style: TextStyle(
                          color: theme.darkblue,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
            )
          ),
        ),
          ListTile(
            // leave room action
              leading: const Icon(Icons.home),
              title: Text("Home",
                  style: TextStyle(
                    color: theme.darkblue,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  )
              ),
              onTap: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => UserHome(email: email),
                  ),
                );
              }
          ),
          ListTile(
            leading: const Icon(Icons.campaign),
            title: Text("Send Announcement",
                style: TextStyle(
                  color: theme.darkblue,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,)
            ),
            onTap: () async{ String hasRoommates = await hasRoommate();
              if(hasRoommates == "true"){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CreateAnnouncement(email: email),
                  ),
                );
              }
              else{
                OurTheme().buildToastMessage("You have no roommates");
              }
          },
        ),
          ListTile(
            // leave room action
              leading: const Icon(Icons.reviews),
              title: Text("Review Roommates",
                  style: TextStyle(
                    color: theme.darkblue,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  )
              ),
              onTap: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ReviewForm(email: email, roomId: roomId,),
                  ),
                );
              }
          ),
          ListTile(
            // leave room action
            leading: const Icon(Icons.exit_to_app),
            title: Text("Leave Room",
                style: TextStyle(
                  color: theme.darkblue,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  )
            ),
            onTap: () async {String warningMsg = await getWarningMsg();
              if(warningMsg == "ERROR")
              {
                OurTheme().buildToastMessage("Request not available please try again later");
              }else{
                _showDialog(context, warningMsg);
              }
            }
          ),
          const SizedBox(height: 30.0),
          ListTile(
            // leave room action
              title: Text("Log Out",
                  style: TextStyle(
                    color: theme.red,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,),
                textAlign: TextAlign.center,
              ),
              onTap: () async { logOut(context, ref);
            }
          )
        ],
      ),
    );
  }

  Future<String> getWarningMsg() async {
    String warning_msg;
    try {
      debugPrint(email);
      var response = await http.get(
        Uri.parse("$user/$email$leaveRoomWarning"),
        headers: {"Content-Type": "application/json"},
      );

      warning_msg =
      await getResponse(response, responseType: 'getLeaveRoomWarning');
    } on UserException catch (e) {
      debugPrint(e.message);
      warning_msg = "ERROR";
    }

    debugPrint(warning_msg);
    return warning_msg;
  }

  void leaveRoom(BuildContext context) async {
    try {
      debugPrint(email);
      var response = await http.get(
        Uri.parse("$user/$email$leaveRoomPth"),
        headers: {"Content-Type": "application/json"},
      );
      await getResponse(response, responseType: 'leaveRoom');
    //   go back to the home page for new users.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => UserHome(email: email),
        ),
      );
    } on UserException catch (e) {
      debugPrint(e.message);
      OurTheme().buildToastMessage(e.message);
    }
  }

  Future<String> hasRoommate() async {
    String hasRoommate = "";
    try {
      debugPrint(email);
      var response =  await http.get(
        Uri.parse("$user/$email$getRoommatePth"),
        headers: {"Content-Type": "application/json"},
      );
      hasRoommate =  await getResponse(response, responseType: 'hasRoommate');
    } on UserException catch (e) {
      debugPrint(e.message);
      OurTheme().buildToastMessage(e.message);
    }
    return hasRoommate;
  }

  void logOut(BuildContext context, WidgetRef ref) async {
    try {
      // Accessing AWS authentication repository using Riverpod provider
      final authAWSRepo = ref.read(authAWSRepositoryProvider);
      await authAWSRepo.logOut(ref);
      // Refresh the auth user provider after signing in
      ref.refresh(authUserProvider);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const OurLogin()));
    } on AuthException catch (e) {
      OurTheme().buildToastMessage(e.message);
    }
  }
}
