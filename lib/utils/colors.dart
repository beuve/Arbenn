import 'package:flutter/material.dart';

enum ColorTheme { light, dark }

class Nuance {
  final Color lighter;
  final Color light;
  final Color main;
  final Color dark;
  final Color darker;
  final Color flash;

  const Nuance(
      {required this.dark,
      required this.darker,
      required this.light,
      required this.lighter,
      required this.main,
      required this.flash});
}

class Palette {
  static const Nuance purple = Nuance(
    lighter: Color(0xFFF7F0FD),
    light: Color(0xFFE9D6FB),
    main: Color(0xFFD9B7F8),
    dark: Color(0xFFCFA5F6),
    darker: Color(0xFFBC80F4),
    flash: Color(0xFF8400FF),
  );

  static const Nuance red = Nuance(
    lighter: Color(0xFFFEECEB),
    light: Color(0xFFF1C1BF),
    main: Color(0xFFEEB2B0),
    dark: Color(0xFFE4A19D),
    darker: Color(0xFFDC8D89),
    flash: Color(0xFFD44A44),
  );

  static const Nuance blue = Nuance(
    lighter: Color(0xFFEBF7FE),
    light: Color(0xFFD8ECFF),
    main: Color(0xFFCCE4FC),
    dark: Color(0xFFA3CAF3),
    darker: Color(0xFF8BB2DE),
    flash: Color(0xFF8BB2DE),
  );

  static const Nuance green = Nuance(
    lighter: Color(0xFFE6FFD0),
    light: Color(0xFFD4F6B6),
    main: Color(0xFFC1E99E),
    dark: Color(0xFF9BC784),
    darker: Color(0xFF7C9B70),
    flash: Color(0xFF7C9B70),
  );

  static const Nuance orange = Nuance(
    lighter: Color(0xFFFFEDD2),
    light: Color(0xFFF9CD8B),
    main: Color(0xFFEEC07B),
    dark: Color(0xFFD7AE72),
    darker: Color(0xFFCAA46D),
    flash: Color(0xFFCAA46D),
  );

  static const Nuance yellow = Nuance(
    lighter: Color(0xFFFFFAD1),
    light: Color(0xFFFFF7AF),
    main: Color(0xFFF1E78E),
    dark: Color(0xFFD8CF81),
    darker: Color(0xFFC0BB89),
    flash: Color(0xFFC0BB89),
  );

  static const Nuance grey = Nuance(
    lighter: Color(0xFFF2F2F2),
    light: Color(0xFFE0E0E0),
    main: Color(0xFFBDBDBD),
    dark: Color(0xFF828282),
    darker: Color(0xFF4F4F4F),
    flash: Color(0xFF4F4F4F),
  );
}
