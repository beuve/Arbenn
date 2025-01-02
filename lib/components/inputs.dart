import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:arbenn/components/location_search/address_search/address_search.dart';
import 'package:arbenn/components/location_search/city_search/city_search.dart';
import 'package:arbenn/data/locations_data.dart';
import 'package:arbenn/utils/page_transitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FormInput extends StatefulWidget {
  final String label;
  final bool autoFocus;
  final int? minLines;
  final int maxLines;
  final TextInputType keyboardType;
  final bool isSmallDevice;
  final TextEditingController? controller;
  final Function()? onTap;
  final bool readOnly;
  final IconData? icon;
  final bool hideButton;
  final Widget? suffixIcon;

  const FormInput({
    required this.label,
    this.controller,
    this.autoFocus = false,
    this.minLines,
    this.maxLines = 1,
    this.isSmallDevice = false,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.hideButton = false,
    this.suffixIcon,
    this.onTap,
    this.icon,
    super.key,
  });

  @override
  State<FormInput> createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
  late bool _textHidden;

  @override
  void initState() {
    super.initState();
    _textHidden = widget.hideButton;
  }

  Widget _hideButton() {
    return TextButton(
      onPressed: () => setState(() => _textHidden = !_textHidden),
      child: Icon(
        _textHidden ? AkarIcons.eye_slashed : AkarIcons.eye_open,
        size: 18,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: false,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: _textHidden,
      readOnly: widget.readOnly,
      maxLines: widget.minLines != null && widget.maxLines < widget.minLines!
          ? widget.minLines
          : widget.maxLines,
      minLines: widget.minLines,
      autofocus: widget.autoFocus,
      onTap: widget.onTap,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            borderRadius: BorderRadius.circular(20.0)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            borderRadius: BorderRadius.circular(20.0)),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            borderRadius: BorderRadius.circular(20.0)),
        hintText: widget.label,
        hintStyle: TextStyle(color: Colors.grey[500]!, fontSize: 16),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        prefixIcon: widget.icon != null
            ? Icon(widget.icon, color: Colors.blue[700], size: 18)
            : null,
        suffixIcon: widget.hideButton ? _hideButton() : widget.suffixIcon,
      ),
      style: const TextStyle(color: Colors.black, fontSize: 16),
    );
  }
}

class SearchInput extends StatelessWidget {
  final String label;
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
    this.controller,
    this.autoFocus = false,
    this.minLines,
    this.maxLines = 1,
    this.isSmallDevice = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        autocorrect: false,
        autofocus: true,
        decoration: InputDecoration(
          hintText: label,
          icon: const Icon(AkarIcons.search, size: 20, color: Colors.black45),
          fillColor: Colors.black,
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)),
          contentPadding: const EdgeInsets.all(5),
        ),
        cursorColor: Colors.blue[700],
        style: const TextStyle(color: Colors.black, fontSize: 15),
      ),
    );
  }
}

class DatePicker extends StatefulWidget {
  final String label;
  final DateTime startDate;
  final DateTime stopDate;
  final DatePickingController controller;
  final BuildContext context;
  final IconData? icon;
  final bool showTime;

  const DatePicker(
    this.context, {
    super.key,
    required this.label,
    required this.controller,
    required this.startDate,
    required this.stopDate,
    this.icon,
    this.showTime = true,
  });

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  late TextEditingController textController;
  late bool showCross;

  @override
  void initState() {
    super.initState();
    textController = widget.controller.textController;
    showCross = textController.text != "";
    textController.addListener(
      () => setState(() => showCross = textController.text != ""),
    );
  }

  erase() {
    widget.controller.date = null;
  }

  @override
  Widget build(BuildContext context) {
    return FormInput(
      label: widget.label,
      icon: widget.icon,
      readOnly: true,
      suffixIcon: showCross
          ? InkWell(
              onTap: erase,
              child: const Icon(AkarIcons.cross, color: Colors.grey, size: 15),
            )
          : null,
      controller: widget.controller.textController,
      onTap: () async {
        await widget.controller
            .pickDate(context, start: widget.startDate, stop: widget.stopDate);
        if (!mounted) return;
        if (widget.showTime) await widget.controller.pickTime(context);
      },
    );
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
    if (value != null) {
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
    if (newDate != null) {
      value = newDate;
    }
  }

  bool hasDate() {
    return date != null;
  }
}

class DateRangePicker extends StatelessWidget {
  final DateTime startDate;
  final DateTime stopDate;
  final DateRangePickingController controller;
  final BuildContext context;

  const DateRangePicker(
    this.context, {
    super.key,
    required this.controller,
    required this.startDate,
    required this.stopDate,
  });

  @override
  Widget build(BuildContext context) {
    final controllers = controller.textController;
    return Row(children: [
      Expanded(
          child: FormInput(
              label: AppLocalizations.of(context)!.from,
              icon: AkarIcons.calendar,
              readOnly: true,
              controller: controllers.first,
              onTap: () {
                controller.pickDateRange(context,
                    start: startDate, stop: stopDate);
              })),
      const SizedBox(width: 15),
      Expanded(
          child: FormInput(
              label: AppLocalizations.of(context)!.to,
              icon: AkarIcons.calendar,
              readOnly: true,
              controller: controllers.last,
              onTap: () {
                controller.pickDateRange(context,
                    start: startDate, stop: stopDate);
              })),
    ]);
  }
}

class DateRangePickingController extends ValueNotifier<DateTimeRange?> {
  DateRangePickingController({
    DateTimeRange? dateRange,
  }) : super(dateRange);

  List<TextEditingController> get textController {
    final TextEditingController fromController =
        TextEditingController(text: text);
    final TextEditingController toController =
        TextEditingController(text: text);
    addListener(() {
      if (value != null) {
        fromController.text =
            "${value!.start.day} / ${value!.start.month} / ${value!.start.year}";
        toController.text =
            "${value!.end.day} / ${value!.end.month} / ${value!.end.year}";
      } else {
        fromController.text = "";
        toController.text = "";
      }
    });
    return [fromController, toController];
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

class CityInputController extends ValueNotifier<City?> {
  CityInputController() : super(null);

  TextEditingController get textController {
    final TextEditingController controller = TextEditingController(text: text);
    addListener(() {
      if (value != null) {
        controller.text = value.toString();
      } else {
        controller.text = "";
      }
    });
    return controller;
  }

  String? get text {
    if (value != null) {
      return value.toString();
    }
    return null;
  }

  City? get city => value;

  set city(City? newCity) {
    value = newCity;
  }

  Future<void> pickCity(BuildContext context) async {
    await Navigator.of(context).push(
      slideIn(
        SearchCity(
          onFinish: (c) => value = c,
        ),
      ),
    );
  }

  bool hasDate() {
    return value != null;
  }
}

class CityInput extends StatefulWidget {
  final String label;
  final CityInputController controller;
  final BuildContext context;
  final IconData? icon;

  const CityInput(
    this.context, {
    super.key,
    required this.label,
    required this.controller,
    this.icon,
  });

  @override
  State<CityInput> createState() => _CityInputState();
}

class _CityInputState extends State<CityInput> {
  late TextEditingController textController;
  late bool showCross;

  @override
  void initState() {
    super.initState();
    textController = widget.controller.textController;
    showCross = textController.text != "";
    textController.addListener(
      () => setState(() => showCross = textController.text != ""),
    );
  }

  erase() {
    widget.controller.city = null;
  }

  @override
  Widget build(BuildContext context) {
    return FormInput(
        label: widget.label,
        icon: widget.icon,
        readOnly: true,
        suffixIcon: showCross
            ? InkWell(
                onTap: erase,
                child:
                    const Icon(AkarIcons.cross, color: Colors.grey, size: 15),
              )
            : null,
        controller: widget.controller.textController,
        onTap: () async {
          await widget.controller.pickCity(context);
        });
  }
}

class AddressInputController extends ValueNotifier<Address?> {
  AddressInputController() : super(null);

  TextEditingController get textController {
    final TextEditingController controller = TextEditingController(text: text);
    addListener(() {
      if (value != null) {
        controller.text = value.toString();
      } else {
        controller.text = "";
      }
    });
    return controller;
  }

  String? get text {
    if (value != null) {
      return value.toString();
    }
    return null;
  }

  Address? get address => value;

  set address(Address? newAdress) {
    value = newAdress;
  }

  Future<void> pickAddress(BuildContext context) async {
    await Navigator.of(context).push(
      slideIn(
        SearchAddress(
          onFinish: (a) => value = a,
        ),
      ),
    );
  }

  bool hasDate() {
    return value != null;
  }
}

class AddressInput extends StatefulWidget {
  final String label;
  final AddressInputController controller;
  final BuildContext context;
  final IconData? icon;

  const AddressInput(
    this.context, {
    super.key,
    required this.label,
    required this.controller,
    this.icon,
  });

  @override
  State<AddressInput> createState() => _AddressInputState();
}

class _AddressInputState extends State<AddressInput> {
  late TextEditingController textController;
  late bool showCross;

  @override
  void initState() {
    super.initState();
    textController = widget.controller.textController;
    showCross = textController.text != "";
    textController.addListener(
      () => setState(() => showCross = textController.text != ""),
    );
  }

  erase() {
    widget.controller.address = null;
  }

  @override
  Widget build(BuildContext context) {
    return FormInput(
      label: widget.label,
      icon: widget.icon,
      readOnly: true,
      suffixIcon: showCross
          ? InkWell(
              onTap: erase,
              child: Icon(
                AkarIcons.cross,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 15,
              ),
            )
          : null,
      controller: widget.controller.textController,
      onTap: () async {
        await widget.controller.pickAddress(context);
      },
    );
  }
}
