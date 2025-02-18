import 'package:flutter/material.dart';

class Nuances {
  final Color main;
  final Color darker;
  final Color dark;
  final Color lighter;
  final Color light;

  const Nuances(
      {required this.main,
      required this.darker,
      required this.dark,
      required this.lighter,
      required this.light});

  static const Nuances blue = Nuances(
    main: Color(0xFFCCE4FC),
    darker: Color(0xFF8BB2DE),
    dark: Color(0xFFA3CAF3),
    lighter: Color(0xFFEBF7FE),
    light: Color(0xFFD8ECFF),
  );

  static const Nuances red = Nuances(
    main: Color(0xFFEEB2B0),
    darker: Color(0xFFDC8D89),
    dark: Color(0xFFE4A19D),
    lighter: Color(0xFFFEECEB),
    light: Color(0xFFF1C1BF),
  );

  static const Nuances pink = Nuances(
      main: Color(0xFFEBA6DD),
      darker: Color(0xFFFFC0CB),
      dark: Color(0xFFFFB6C1),
      lighter: Color(0xFFFFF0F5),
      light: Color(0xFFFFE4E1));

  static const Nuances yellow = Nuances(
    main: Color(0xFFFFFACD),
    darker: Color(0xFFFFFAF0),
    dark: Color(0xFFFFFFF0),
    lighter: Color(0xFFFFFFE0),
    light: Color(0xFFFFFACD),
  );

  static const Nuances green = Nuances(
    main: Color(0xFFC1E99E),
    darker: Color(0xFF2B4B17),
    dark: Color(0xFF9BC784),
    lighter: Color(0xFFE6FFD0),
    light: Color(0xFFD4F6B6),
  );

  static const Nuances purple = Nuances(
    main: Color(0xFFD9B7F8),
    darker: Color(0xFFBC80F4),
    dark: Color(0xFFCFA5F6),
    lighter: Color(0xFFF7F0FD),
    light: Color(0xFFE9D6FB),
  );

  static const Nuances teal = Nuances(
    main: Color(0xFF84ABB6),
    darker: Color(0xFF5B8F9E),
    dark: Color(0xFF6697A5),
    lighter: Color(0xFFBCD1D7),
    light: Color(0xFFA5C1C9),
  );

  static const Nuances orange = Nuances(
    main: Color(0xFFEEC07B),
    darker: Color(0xFFCAA46D),
    dark: Color(0xFFD7AE72),
    lighter: Color(0xFFE6FFD0),
    light: Color(0xFFF9CD8B),
  );

  static Nuances get(String name) {
    switch (name) {
      case "green":
        return Nuances.green;
      case "yellow":
        return Nuances.yellow;
      case "blue":
        return Nuances.blue;
      case "purple":
        return Nuances.purple;
      case "teal":
        return Nuances.teal;
      case "red":
        return Nuances.red;
      case "orange":
        return Nuances.orange;
      case "pink":
        return Nuances.pink;
      default:
        return Nuances.purple;
    }
  }
}
