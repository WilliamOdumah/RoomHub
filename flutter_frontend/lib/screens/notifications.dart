import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_frontend/widgets/header.dart';
import 'package:flutter_frontend/widgets/action_notification.dart';
import 'package:flutter_frontend/widgets/match_notification.dart';
import 'package:flutter_frontend/widgets/notification_item.dart';
import 'package:flutter_frontend/utils/our_theme.dart';
import 'package:flutter_frontend/widgets/noaction_notification.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_frontend/config.dart';

import '../utils/custom_exceptions.dart';
import '../utils/response_handler.dart';

class Notifications extends StatefulWidget {
  // final List<NotificationItem> notificationItems;
  final String email;
  const Notifications(
      {super.key,
      // required this.notificationItems, // Marking the list as required
      required this.email});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final theme = OurTheme();
  List<NotificationItem>? notificationItems;
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();

    getNotificationsCaller();
  }

  Future<void> getNotificationsCaller() async {
    // Simulate an API request or some async operation
    List<NotificationItem>? items = await getNotifications(widget.email);
    // Update the loading state and rebuild the UI
    setState(() {
      // isLoading = false; // Update loading state
      notificationItems = items;
      // choose selected roommate after roommate has been selected
      // selectedRoommate = widget.assignedTo;
    });
  }

  void removeNotification(String id) {
    debugPrint("Notification fe removed");
    setState(() {
      notificationItems!.removeWhere((item) => item.notificationid == id);
    });

    // Make an API call to remove the notification from the backend
    removeNotificationFromBackend(id);
  }

  Future<void> removeNotificationFromBackend(id) async {
    debugPrint("rmv notif backend");

    String userEmail = widget.email;
    debugPrint(userEmail);
    try {
      var response = await http.delete(
        Uri.parse("$user/$userEmail/notification/" + id),
        headers: {"Content-Type": "application/json"},
      );
      await deleteResponse(response, responseType: "deleteNotification");
      theme.buildToastMessage("Notification deleted successfully");
    } on NotificationException catch (e) {
      theme.buildToastMessage(e.message);
    } on UserException catch (e) {
      theme.buildToastMessage(e.message);
    }
  }

  // Simulate a data fetch and refresh operation
  Future<void> _refreshData() async {
    List<NotificationItem>? items = await getNotifications(widget.email);

    setState(() {
      // Add new items to simulate data change
      notificationItems = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            RefreshIndicator(
              onRefresh: _refreshData,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50), // Space for the back button
                      Center(
                        child: Text(
                          "Notifications",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      const SizedBox(height: 10),
                      notificationItems == null
                          ? const Center(
                              child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: CircularProgressIndicator()))
                          : notificationItems!.isEmpty
                              ? Center(
                                  child: Text(
                                    '\n\nNo notifications',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(color: theme.darkblue),
                                  ),
                                )
                              : NotificationList(
                                  items: notificationItems!,
                                  onRemoveNotification: removeNotification,
                                ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical:
                        10), // Padding to create space for the back button

                // width: double.infinity,
                decoration: BoxDecoration(
                    //color: Colors.white,
                    borderRadius: BorderRadius.circular(50)),
                child: Row(children: [
                 IconButton(
                  icon:  Icon(
                    Icons.arrow_back,
                    color:theme.darkblue ,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Pop the current screen
                  },
                ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<NotificationItem>?> getNotifications(String email) async {
    List<NotificationItem>? items;
    try {
      print("${url}user/$email/get-notification");
      var response = await http.get(
        Uri.parse("${url}user/$email/get-notification"),
        headers: {"Content-Type": "application/json"},
      );
      print("${url}user/$email/get-notification");
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        items = NotificationItem.parseNotificationList(jsonData);
      } else {
        await getResponse(response, responseType: 'getUserNotification');
      }
    } on UserException catch (e) {
      print(e.toString());
      theme.buildToastMessage(e.message);
    }
    return items;
  }
}

class NotificationList extends StatelessWidget {
  final List<NotificationItem> items;
  final Function(String id) onRemoveNotification;

  const NotificationList(
      {super.key, required this.items, required this.onRemoveNotification});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (context, index) {
          if (items[index].type == "announcement") {
            return NoActionNotification(
              message: items[index].msg,
              id: items[index].notificationid,
              onRemove: onRemoveNotification,
            );
          } else if (items[index].type == "join-request") {
            return ActionNotification(
              message: items[index].msg,
              id: items[index].notificationid,
              new_roommate: items[index].from,
              onRemove: onRemoveNotification,
            );
          } else if (items[index].type == "match") {
            print(items[index].from);
            return MatchNotification(
                message: items[index].msg,
                id: items[index].notificationid,
                liked_id: items[index].from,
                onRemove: onRemoveNotification);
          }

          return null;
        },
      ),
    );
  }

  void printNotificationList(List<NotificationItem> notifications) {
    for (var notification in notifications) {
      print(notification); // This will call the toString method
    }
  }
}
