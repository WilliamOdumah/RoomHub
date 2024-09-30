import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/signup/localwidgets/signupform.dart';


class OurSignUp extends StatelessWidget {
  const OurSignUp ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20.0),
              children: 
             const <Widget>[
                Row(
                  mainAxisAlignment:MainAxisAlignment.start,
                  children:  [
                  Padding(
                    padding: EdgeInsets.only(top: 40.0, left: 10.0), // Adjust padding values here
                    child: BackButton(),
                  ),
                ],
                ),
                SignUpForm()
              ],
            ),
          )
        ],
      ),
    );
  }
}
