import 'package:flutter/material.dart';
import '../utils/colors.dart';

class Button extends StatelessWidget {
  final Nuance color;
  final String label;
  final Function() onPressed;

  const Button(
      {Key? key,
      required this.color,
      required this.label,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        child: Text(
          label,
          style: TextStyle(color: color.lighter, fontSize: 19),
        ),
        decoration: BoxDecoration(
          color: color.darker,
          borderRadius: const BorderRadius.all(Radius.circular(25)),
        ),
      ),
    );
  }
}
