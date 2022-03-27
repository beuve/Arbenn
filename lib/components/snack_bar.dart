import 'package:arbenn/utils/colors.dart';
import 'package:flutter/material.dart';

showSnackBar({
  required BuildContext context,
  required String text,
  required Nuance color,
  ColorTheme colorTheme = ColorTheme.light,
  int seconds = 1,
}) {
  SnackBar snackBar = SnackBar(
    content: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: colorTheme == ColorTheme.light ? color.lighter : color.darker,
        fontSize: 18,
      ),
    ),
    duration: Duration(seconds: seconds),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    behavior: SnackBarBehavior.floating,
    backgroundColor: colorTheme == ColorTheme.light ? color.dark : color.light,
  );

  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
