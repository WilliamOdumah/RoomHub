import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/notifications.dart';
import 'package:flutter_frontend/screens/userProfile/create_profile.dart';
import 'package:flutter_frontend/screens/userProfile/update_profile.dart';
import 'package:flutter_frontend/utils/our_theme.dart';
import 'package:flutter_frontend/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_frontend/utils/custom_exceptions.dart';
import 'package:flutter_frontend/utils/response_handler.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_frontend/config.dart';
import 'dart:convert';
import 'notification_item.dart';

class HeaderProfile extends ConsumerStatefulWidget {
  // this is used to detect whether or not the drawer will be displayed.
  const HeaderProfile({super.key});

  @override
  ConsumerState<HeaderProfile> createState() => _ActionNotificationState();
}

class _ActionNotificationState extends ConsumerState<HeaderProfile> {
  final theme = OurTheme();
  late String userEmail;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> getNotifications(String email) async {
    bool success = false;
    try {
      var response = await http.get(
        Uri.parse("${url}user/$email/get-notification"),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        List<NotificationItem> notifications =
            NotificationItem.parseNotificationList(jsonData);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Notifications(email: email),
          ),
        );
        success = true;
      } else {
        await getResponse(response, responseType: 'getUserNotification');
      }
    } on UserException catch (e) {
      print(e.toString());
      theme.buildToastMessage(e.message);
    }
    return success;
  }

  @override
  Widget build(BuildContext context) {
    userEmail = ref.read(emailProvider);

    return Builder(builder: (context) {
      return Container(
        color: Colors.grey[300],
        height: 110,
        child: Column(
          children: [
            Container(
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 20),
                      child: IconButton(
                        icon: Icon(
                          Icons.person,
                          color: theme.darkblue,
                          size: 34.0,
                        ),
                        onPressed: () async {
                          bool hasProf = await hasProfile(userEmail);
                          print(hasProf);
                          if (hasProf) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditProfile(userId: userEmail),
                              ),
                            );
                          } else {
                            print("pushing correct page");
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    CreateProfile(userId: userEmail),
                              ),
                            );
                          }
                        },
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      'RoomHub',
                      style: TextStyle(
                        color: theme.darkblue,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0, top: 20),
                    child: IconButton(
                      icon: Icon(
                        Icons.notifications,
                        color: theme.darkblue,
                        size: 34.0,
                      ),
                      onPressed: () async {
                        print("Notification button pressed");
                        await getNotifications(userEmail);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
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
}
