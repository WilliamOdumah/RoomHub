import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:lottie/lottie.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'dart:async';

class ComingSoonPage extends StatefulWidget {
  const ComingSoonPage({super.key});

  @override
  _ComingSoonPageState createState() => _ComingSoonPageState();
}

class _ComingSoonPageState extends State<ComingSoonPage> {
  @override
  void initState() {
    super.initState();
    // Set a timer to go back to the previous screen after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pop(context); // Go back to the previous screen
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: const Column(
        children: [
          Center(
            child: Text(
              "COMING SOON",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      splashIconSize: 400,
      backgroundColor: const Color.fromARGB(255, 22, 31, 42),
      nextScreen: const SizedBox(), // Dummy widget, needed for nextScreen
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}
