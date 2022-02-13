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
  final Function()? onTap;
  final bool readOnly;

  const FormInput({
    required this.label,
    required this.color,
    this.controller,
    this.autoFocus = false,
    this.minLines,
    this.maxLines = 1,
    this.isSmallDevice = false,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: false,
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      maxLines: minLines != null && maxLines < minLines! ? minLines : maxLines,
      minLines: minLines,
      autofocus: autoFocus,
      onTap: onTap,
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
  final String label;
  final Color color;
  final DatePickingController controller;
  final BuildContext context;

  const DatePicker(
    this.context, {
    Key? key,
    required this.label,
    required this.controller,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormInput(
        label: label,
        color: color,
        readOnly: true,
        controller: controller.textController,
        onTap: () => controller.pickDate(context));
  }
}

class DatePickingController extends ValueNotifier<DateTime?> {
  DatePickingController({DateTime? date}) : super(date);

  TextEditingController get textController {
    final TextEditingController controller = TextEditingController(text: text);
    addListener(() {
      if (value != null) {
        controller.text = "${value!.day} / ${value!.month} / ${value!.year}";
      } else {
        controller.text = "";
      }
    });
    return controller;
  }

  String? get text {
    if (value != null && value != null) {
      return "${value!.day} / ${value!.month} / ${value!.year}";
    }
    return null;
  }

  DateTime? get date => value;

  set date(DateTime? newDate) {
    value = newDate;
  }

  Future<void> pickDate(BuildContext context) async {
    value = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2015, 8),
          lastDate: DateTime(2101),
        ) ??
        value;
  }
}
