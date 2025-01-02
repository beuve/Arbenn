import 'package:flutter/material.dart';

showSnackBar({
  required BuildContext context,
  required String text,
  int seconds = 1,
}) {
  SnackBar snackBar = SnackBar(
    content: Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 18,
      ),
    ),
    duration: Duration(seconds: seconds),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.white,
  );

  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
