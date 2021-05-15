import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:kycha/screen/signin_screen.dart';
import 'package:kycha/screen/signup_screen.dart';

class AuthLocation extends BeamLocation {
  AuthLocation(BeamState state);
  @override
  List<BeamPage> pagesBuilder(BuildContext context, BeamState state) => [
        BeamPage(
          key: ValueKey("signIn"),
          child: SignInScreen(),
        ),
        if (state.uri.pathSegments.contains('signUp'))
          BeamPage(
            key: ValueKey('signUp'),
            child: SignUpScreen(),
          )
      ];

  @override
  List<String> get pathBlueprints => [];
}

class ChatLocation extends BeamLocation {
  ChatLocation(BeamState state);
  @override
  List<BeamPage> pagesBuilder(BuildContext context, BeamState state) => [];

  @override
  // TODO: implement pathBlueprints
  List<String> get pathBlueprints => throw UnimplementedError();
}
