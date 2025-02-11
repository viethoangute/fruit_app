import 'package:flutter/material.dart';

class SnackBarHelper {
  static void showMessage(
      {required BuildContext context,
      required String message,
      Duration? duration,
      String? hideAction}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: duration ?? const Duration(seconds: 2),
      action: hideAction == null ? null : SnackBarAction(
        label: hideAction,
        onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      ),
    ));
  }
}
