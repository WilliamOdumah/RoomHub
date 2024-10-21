import 'package:flutter/material.dart';
import 'join_room_form.dart';

class JoinRoom extends StatelessWidget {
  const JoinRoom({super.key});

  @override
   Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: const JoinRoomForm(),
    );
  }
}

