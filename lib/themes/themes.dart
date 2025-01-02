import 'package:arbenn/themes/color_theme.dart';
import 'package:arbenn/themes/elevated_button_theme.dart';
import 'package:arbenn/themes/icon_button.dart';
import 'package:flutter/material.dart';

final appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: colorTheme,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: colorTheme.primary,
    elevation: 0,
  ),
  elevatedButtonTheme: elevatedButtonTheme,
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      textStyle: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  navigationBarTheme: NavigationBarThemeData(),
  iconButtonTheme: iconButtonTheme,
  buttonTheme: const ButtonThemeData(
    padding: EdgeInsets.zero,
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  ),
);
