import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/header.dart';
import 'package:flutter_frontend/widgets/action_notification.dart';

import 'package:flutter_frontend/utils/our_theme.dart';

class Notifications extends StatefulWidget {
  final List<NotificationItem> notificationItems;
  const Notifications({
    super.key,
    required this.notificationItems, // Marking the list as required
  });

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final theme = OurTheme();
  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60), // Space for the back button
                    Text(
                      "New",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 10),
                    widget.notificationItems.isEmpty
                        ? Center(
                            child: Text(
                              'No notifications',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: theme.darkblue),
                            ),
                          )
                        : NotificationList(items: widget.notificationItems),

    
                    // List of new notifications

                    
                  ],
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: BackButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Go back to the previous screen
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationList extends StatelessWidget {
  final List<NotificationItem> items;

  const NotificationList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ActionNotification(
          message: items[index].msg,
          id: items[index].notificationid,
          new_roommate: items[index].from,
        );
      },
    );
  }

  void printNotificationList(List<NotificationItem> notifications) {
    for (var notification in notifications) {
      print(notification); // This will call the toString method
    }
  }
}
