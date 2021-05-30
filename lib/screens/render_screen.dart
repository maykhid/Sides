import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trove_app/screens/home_screen.dart';
import 'package:trove_app/screens/login_screen.dart';
import 'package:trove_app/screens/signup_screen.dart';
import 'package:trove_app/services/auth.dart';

class RenderScreen extends StatelessWidget {
  static String route = 'RenderScreen';
  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      // ignore: missing_return
      builder: (context, auth, _) {
        switch (auth.status){
          case Status.Unininitialized:
          case Status.Unauthenticated:
            return LoginScreen();
          case Status.Authenticating:
            return LoadingScreen();
          case Status.Authenticated:
            return HomeScreen();
          case Status.NewUser:
            return SignUpScreen();
        }
      },
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

