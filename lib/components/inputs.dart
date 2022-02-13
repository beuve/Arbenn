import 'package:flutter/material.dart';
import '../utils/colors.dart';

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

class SearchInput extends StatelessWidget {
  final String label;
  final Nuance color;
  final bool autoFocus;
  final int? minLines;
  final int maxLines;
  final TextInputType keyboardType;
  final bool isSmallDevice;
  final Function(String)? onChanged;

  const SearchInput({
    required this.label,
    required this.color,
    this.autoFocus = false,
    this.minLines,
    this.maxLines = 1,
    this.isSmallDevice = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: false,
      autofocus: autoFocus,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: color.dark, width: 2)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: color.dark, width: 2)),
        disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: color.dark, width: 2)),
        hintText: label,
        hintStyle: TextStyle(color: color.main, fontSize: 20),
      ),
      style: TextStyle(color: color.dark, fontSize: 20),
    );
  }
}

class DatePicker extends StatelessWidget {
  final Color color;
  final String label;
  final TextEditingController controller;

  const DatePicker({
    Key? key,
    required this.color,
    required this.label,
    required this.controller,
  }) : super(key: key);

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      controller.text = "${picked.day} / ${picked.month} / ${picked.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: false,
      onTap: () => _selectDate(context),
      readOnly: true,
      controller: controller,
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
