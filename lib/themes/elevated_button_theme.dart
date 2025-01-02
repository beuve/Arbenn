import 'package:arbenn/themes/color_theme.dart';
import 'package:flutter/material.dart';

final elevatedButtonTheme = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: colorTheme.primary,
    disabledBackgroundColor: colorTheme.secondary,
    minimumSize: const Size(double.infinity, 50),
    elevation: 0,
    foregroundColor: colorTheme.onPrimary,
    disabledForegroundColor: colorTheme.onSecondary,
    textStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    iconColor: Colors.white,
    disabledIconColor: colorTheme.primary,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
  ),
);
