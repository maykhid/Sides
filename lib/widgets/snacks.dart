import 'package:flutter/material.dart';

class GlobalSnackBar {
  final String message;

  const GlobalSnackBar({
    @required this.message,
  });

  static show(BuildContext context, String message,
      {String route, int duration = 50000}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0.0,
        //behavior: SnackBarBehavior.floating,
        content: Text(message),
        duration: new Duration(seconds: duration),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
        ),
        //backgroundColor: Colors.redAccent,
        action: SnackBarAction(
          textColor: Color(0xFFFAF2FB),
          label: 'OK',
          onPressed: () =>
              Navigator.of(context).popUntil((route) => route.isFirst),
          // Navigator.of(context).pop(),
        ),
      ),
    );
  }

  static showNetworkSnackbar(message, Color color, int seconds) {
    return SnackBar(
      elevation: 0.0,
      backgroundColor: color,
      // behavior: SnackBarBehavior.floating,
      content: Text(message),
      duration: new Duration(seconds: seconds),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
      ),
    );
  }

  static showAuthSnackbar(context, message, Color color, int seconds) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0.0,
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        content: Text(message),
        duration: new Duration(seconds: seconds),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
              bottomLeft: Radius.circular(16.0),
              bottomRight: Radius.circular(16.0)),
        ),
      ),
    );
  }
}
