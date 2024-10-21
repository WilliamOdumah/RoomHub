import 'package:flutter/material.dart';
import 'package:flutter_frontend/widgets/action_button.dart';
import 'package:flutter_frontend/utils/our_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_frontend/providers.dart';
import 'package:flutter_frontend/utils/custom_exceptions.dart';
import 'package:flutter_frontend/utils/response_handler.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_frontend/config.dart';
import 'dart:convert';

class ActionNotification extends ConsumerStatefulWidget {
  final String message;
  final String id;
  final String new_roommate;

  const ActionNotification(
      {super.key,
      required this.message,
      required this.id,
      required this.new_roommate});

  @override
  ConsumerState<ActionNotification> createState() => _ActionNotificationState();
}

class _ActionNotificationState extends ConsumerState<ActionNotification> {
  final theme = OurTheme();
  late String userEmail;

  @override
  void initState() {
    super.initState();
    // Store the email in initState
  }

  @override
  Widget build(BuildContext context) {
    userEmail = ref.read(emailProvider);
    return Container(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 5,
              child: SizedBox(
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      widget.message,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                            child: ActionButton(
                                text: "Accept",
                                onTap: () async {
                                  if(await addRoommateBE(widget.new_roommate)){
                                      theme.buildToastMessage(
                                      "New Roommate succesfully added");
                                  }
                                  Navigator.pop(context);
                                },
                                color: theme.mintgreen)),
                        const Padding(
                          padding: EdgeInsets.only(right: 10),
                        ),
                        Expanded(
                            child: ActionButton(
                                text: "Reject", color: theme.darkgrey)),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Future<bool> addRoommateBE(String newRoommate) async {
    String roomName = await getRoomName(userEmail);
    bool createSuccess = false;
    try {
      var regBody = {
        "existing_roommate": userEmail,
        "new_roommate": newRoommate,
        "room_nm": roomName,
        "notification_id": widget.id
      };

      print(regBody);
      var response = await http.post(
        Uri.parse(addRoommate),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );
      print(response.body);
      print(response.statusCode);
      await handlePost(response, responseType: 'createRoom');
      createSuccess = true;
    } on UserException catch (e) {
      print(e.message);
      theme.buildToastMessage(e.message);
    }
    return createSuccess;
  }

  Future<String> getRoomName(String from) async {
    String roomName = '';
    try {
      var response = await http.get(
        Uri.parse("${url}user/$from/get-room"),
        headers: {"Content-Type": "application/json"},
      );
      print(response.body);

      // Await the response from getResponse
      roomName = await getResponse(response, responseType: 'getUserRoom');
      // After successful response, navigate to the next screen
      print(roomName);
    } on UserException catch (e) {
      print(e.toString());
      theme
          .buildToastMessage(e.message); // Display error if an exception occurs
    }
    return roomName;
  }
}
