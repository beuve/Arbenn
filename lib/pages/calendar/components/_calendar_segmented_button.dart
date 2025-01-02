import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:arbenn/pages/calendar/styles/_calendar_segmented_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalendarSegmentedButton extends StatelessWidget {
  final Function(Set<bool>) onChange;
  final bool showPastEvent;

  const CalendarSegmentedButton({
    super.key,
    required this.onChange,
    required this.showPastEvent,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      segments: [
        ButtonSegment(
            label: Text(AppLocalizations.of(context)!.past), value: true),
        ButtonSegment(
            label: Text(AppLocalizations.of(context)!.futur), value: false)
      ],
      style: calendarSegementedButtonStyle,
      showSelectedIcon: true,
      selected: {showPastEvent},
      onSelectionChanged: onChange,
      selectedIcon:
          Icon(showPastEvent ? AkarIcons.arrow_back : AkarIcons.arrow_forward),
    );
  }
}
