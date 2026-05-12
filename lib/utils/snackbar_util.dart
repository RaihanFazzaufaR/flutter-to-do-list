import 'package:flutter/material.dart';

class SnackbarUtil {
  static final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  static void showSnackBar(String message, {Color backgroundColor = Colors.black87}) {
    messengerKey.currentState?.hideCurrentSnackBar();
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showError(String message) {
    showSnackBar(message, backgroundColor: Colors.redAccent);
  }

  static void showSuccess(String message) {
    showSnackBar(message, backgroundColor: Colors.green);
  }
}
