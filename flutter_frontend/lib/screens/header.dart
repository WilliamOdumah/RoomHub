import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/notifications.dart';
import 'package:flutter_frontend/utils/our_theme.dart';

import 'package:flutter_frontend/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_frontend/utils/custom_exceptions.dart';
import 'package:flutter_frontend/utils/response_handler.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_frontend/config.dart';
import 'dart:convert';

class Header extends ConsumerStatefulWidget {
  const Header({super.key});

  @override
  ConsumerState<Header> createState() => _ActionNotificationState();
}

class _ActionNotificationState extends ConsumerState<Header> {
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
      print("Response status: ${response.statusCode}");
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        List<NotificationItem> notifications =
            NotificationItem.parseNotificationList(jsonData);
            for (var notification in notifications) {
            print(notification); // This will call the toString method
    } 
        print("Navigating to notifications screen");
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Notifications(notificationItems: notifications),
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
    print(userEmail);
    return Container(
      color: Colors.grey[300],
      height: 135,
      child: Column(
        children: [
          Container(
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 50),
                  child: Icon(
                    Icons.menu,
                    color: Colors.grey[300],
                    size: 34.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
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
                  padding: const EdgeInsets.only(right: 16.0, top: 50),
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
  }
}


class NotificationItem {
  final String type;
  final String msg;
  final String from;
  final String notificationid;
  NotificationItem(
      {required this.type,
      required this.msg,
      required this.from,
      required this.notificationid});

  // Factory constructor to create a NotificationItem from JSON
  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      from: json['from'],
      type: json['type'],
      msg: json['msg'],
      notificationid: json['notification_id'],
    );
  }

  static List<NotificationItem> parseNotificationList(
      Map<String, dynamic> json) {
    // Access the 'All_Notifications' array
    final notifications = json['All_Notifications'] as List<dynamic>;

    // Map the list of JSON objects to NotificationItem objects
    return notifications.map((item) {
      return NotificationItem.fromJson(item as Map<String, dynamic>);
    }).toList();
  }
  // Override toString method to provide a string representation
  @override
  String toString() {
    return 'NotificationItem{'
        'type: $type, '
        'msg: $msg, '
        'from: $from, '
        'notificationid: $notificationid'
        '}';
  }

  
}
