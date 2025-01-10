import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/notifications.dart';
import 'package:flutter_frontend/utils/our_theme.dart';
import 'notification_item.dart';
import 'package:flutter_frontend/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class Header extends ConsumerStatefulWidget {
  // this is used to detect whether or not the drawer will be displayed.
  final String? roomId;

  const Header({super.key, this.roomId});



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


  @override
  Widget build(BuildContext context) {
    userEmail = ref.read(emailProvider);
    String? currRoomId = widget.roomId;
    return Builder(
      builder: (context) {
        return Container(
          color: Colors.grey[300],
          height: 107,
          child: Column(
            children: [
              Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 10),
                      child: currRoomId != null ? IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: theme.darkblue,
                          size: 34.0,
                        ),
                        onPressed: () {
                          Scaffold.of(context).openDrawer(); // Opens the drawer
                        },
                      ):null,
                    ),
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
                          // await getNotifications(userEmail);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Notifications(email: userEmail),
                            ),
                          );
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
    );
  }
}
