import 'package:flutter/material.dart';
import 'package:kycha/screen/signin_screen.dart';
import 'package:kycha/screen/signup_screen.dart';

class AuthenticateToggle extends StatefulWidget {
  @override
  _AuthenticateToggleState createState() => _AuthenticateToggleState();
}

class _AuthenticateToggleState extends State<AuthenticateToggle> {
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignInScreen(
        toggle: toggleView,
      );
    } else {
      return SignUpScreen(
        toggle: toggleView,
      );
    }
  }
}
