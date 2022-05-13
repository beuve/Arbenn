import 'package:flutter/material.dart';
import 'package:arbenn/utils/colors.dart';

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
  final TextEditingController? controller;
  final Function()? onTap;
  final bool readOnly;

  const SearchInput({
    required this.label,
    required this.color,
    this.controller,
    this.autoFocus = false,
    this.minLines,
    this.maxLines = 1,
    this.isSmallDevice = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: false,
      controller: controller,
      autofocus: autoFocus,
      keyboardType: keyboardType,
      onChanged: onChanged,
      onTap: onTap,
      readOnly: readOnly,
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
class DatePicker extends StatefulWidget {
final String label;
  final Nuance color;
  final DateTime startDate;
  final DateTime stopDate;
  final DatePickingController controller;
  final BuildContext context;
  final bool searchDesign;

  const DatePicker(
    this.context, {
    Key? key,
    required this.label,
    required this.controller,
    required this.color,
    required this.startDate,
    required this.stopDate,
    this.searchDesign = false,
  }) : super(key: key);

 @override
 State<DatePicker>  createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
    @override
  Widget build(BuildContext context) {
    if (widget.searchDesign) {
      return SearchInput(
          label: widget.label,
          color: widget.color,
          readOnly: true,
          controller: widget.controller.textController,
          onTap: () async {
          await widget.controller.pickDate(context, start: widget.startDate, stop: widget.stopDate);
          if (!mounted) return;
          await widget.controller.pickTime(context);
        });
    }
    return FormInput(
        label: widget.label,
        color: widget.color.darker,
        readOnly: true,
        controller: widget.controller.textController,
        onTap: () async {
          await widget.controller.pickDate(context, start: widget.startDate, stop: widget.stopDate);
          if (!mounted) return;
          await widget.controller.pickTime(context);
        });
  }
}

class DatePickingController extends ValueNotifier<DateTime?> {
  final bool showTime;

  DatePickingController({DateTime? date, this.showTime = false}) : super(date);

  TextEditingController get textController {
    final TextEditingController controller = TextEditingController(text: text);
    addListener(() {
      if (value != null) {
        String time = showTime ? "  ${value!.hour}:${value!.minute}" : "";
        controller.text =
            "${value!.day} / ${value!.month} / ${value!.year}$time";
      } else {
        controller.text = "";
      }
    });
    return controller;
  }

  String? get text {
    if (value != null && value != null) {
      String time = showTime ? "  ${value!.hour}:${value!.minute}" : "";
      return "${value!.day} / ${value!.month} / ${value!.year}$time";
    }
    return null;
  }

  DateTime? get date => value;

  set date(DateTime? newDate) {
    value = newDate;
  }

  Future<void> pickTime(BuildContext context) async {
    if (value != null) {
      TimeOfDay? t = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 0, minute: 0),
      );
      if (t != null) {
        value =
            DateTime(value!.year, value!.month, value!.day, t.hour, t.minute);
      }
    }
  }

  Future<void> pickDate(BuildContext context,
      {required DateTime start, required DateTime stop, DateTime? init}) async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: init ?? stop,
      firstDate: start,
      lastDate: stop,
    );
    value = newDate;
  }
}

class DateRangePicker extends StatelessWidget {
  final String label;
  final Nuance color;
  final DateTime startDate;
  final DateTime stopDate;
  final DateRangePickingController controller;
  final BuildContext context;
  final bool searchDesign;

  const DateRangePicker(
    this.context, {
    Key? key,
    required this.label,
    required this.controller,
    required this.color,
    required this.startDate,
    required this.stopDate,
    this.searchDesign = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (searchDesign) {
      return SearchInput(
          label: label,
          color: color,
          readOnly: true,
          controller: controller.textController,
          onTap: () {
            controller.pickDateRange(context, start: startDate, stop: stopDate);
          });
    }
    return FormInput(
        label: label,
        color: color.darker,
        readOnly: true,
        controller: controller.textController,
        onTap: () {
          controller.pickDateRange(context, start: startDate, stop: stopDate);
        });
  }
}

class DateRangePickingController extends ValueNotifier<DateTimeRange?> {
  DateRangePickingController({
    DateTimeRange? dateRange,
  }) : super(dateRange);

  TextEditingController get textController {
    final TextEditingController controller = TextEditingController(text: text);
    addListener(() {
      if (value != null) {
        controller.text =
            "${value!.start.day} / ${value!.start.month} / ${value!.start.year} - ${value!.end.day} / ${value!.end.month} / ${value!.end.year}";
      } else {
        controller.text = "";
      }
    });
    return controller;
  }

  String? get text {
    if (value != null && value != null) {
      return "${value!.start.day} / ${value!.start.month} / ${value!.start.year} - ${value!.end.day} / ${value!.end.month} / ${value!.end.year}";
    }
    return null;
  }

  DateTimeRange? get dateRange => value;
  DateTimeRange? get start => value;
  DateTimeRange? get end => value;

  set date(DateTimeRange? newDateRange) {
    value = newDateRange;
  }

  Future<void> pickDateRange(BuildContext context,
      {required DateTime start,
      required DateTime stop,
      DateTimeRange? init}) async {
    DateTimeRange? newDate = await showDateRangePicker(
      context: context,
      initialDateRange: init,
      firstDate: start,
      lastDate: stop,
    );
    value = newDate;
  }
}
