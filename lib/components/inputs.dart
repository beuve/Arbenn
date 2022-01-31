import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  final String label;
  final Color color;
  final bool autoFocus;
  final int? minLines;
  final int maxLines;
  final TextInputType keyboardType;
  final bool isSmallDevice;
  final TextEditingController? controller;

  const FormInput({
    required this.label,
    required this.color,
    this.controller,
    this.autoFocus = false,
    this.minLines,
    this.maxLines = 1,
    this.isSmallDevice = false,
    this.keyboardType = TextInputType.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: false,
      controller: controller,
      keyboardType: keyboardType,
      maxLines: minLines != null && maxLines < minLines! ? minLines : maxLines,
      minLines: minLines,
      autofocus: autoFocus,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: color, width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(30.0))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: color, width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(30.0))),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: color, width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(30.0))),
        labelText: label,
        labelStyle: TextStyle(color: color, fontSize: 20),
        contentPadding: const EdgeInsets.all(25),
      ),
      style: TextStyle(color: color, fontSize: 20),
    );
  }
}
