import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/login/login_form.dart';

class OurLogin extends StatelessWidget {
  const OurLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20.0),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 90,right: 30,left: 30),
                  child: Image.asset(
                    "assets/logo.png",
                    height: 250, width: 250,
                  ),
                ),
                const OurLoginForm()
              ],
            ),
          )
        ],
      ),
    );
  }
}
