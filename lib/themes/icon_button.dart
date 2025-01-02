import 'package:arbenn/themes/color_theme.dart';
import 'package:flutter/material.dart';

final iconButtonTheme = IconButtonThemeData(
  style: IconButton.styleFrom(
    backgroundColor: colorTheme.primary,
    disabledBackgroundColor: colorTheme.secondary,
    fixedSize: const Size(60, 60),
    elevation: 0,
    iconSize: 25,
    foregroundColor: colorTheme.onPrimary,
    disabledForegroundColor: colorTheme.onSecondary,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(30),
      ),
    ),
  ),
);
