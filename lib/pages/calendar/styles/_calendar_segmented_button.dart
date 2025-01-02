import 'package:flutter/material.dart';

final ButtonStyle calendarSegementedButtonStyle = ButtonStyle(
  foregroundColor:
      WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
    if (states.contains(WidgetState.selected)) {
      return Colors.blue[800]!;
    }
    return Colors.white;
  }),
  backgroundColor: WidgetStateProperty.resolveWith<Color>(
    (Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.blue[50]!;
      }
      return Colors.blue[800]!;
    },
  ),
  padding: WidgetStateProperty.all<EdgeInsets>(
    const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
  ),
  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  ),
  side: WidgetStateProperty.all<BorderSide>(
    const BorderSide(color: Colors.transparent),
  ),
);
