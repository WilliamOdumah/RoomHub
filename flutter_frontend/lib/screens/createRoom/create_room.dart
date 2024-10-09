import 'package:flutter/material.dart';
import 'create_room_form.dart';

class CreateRoom extends StatelessWidget {
  const CreateRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: const CreateRoomForm(),
    );
  }
}
