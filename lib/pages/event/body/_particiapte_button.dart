import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:arbenn/data/event/event_data.dart';
import 'package:arbenn/pages/event/_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventPageParticipateButton extends StatelessWidget {
  final EventData event;
  final Function() removeAttende;
  final Function() addAttende;

  const EventPageParticipateButton({
    super.key,
    required this.event,
    required this.addAttende,
    required this.removeAttende,
  });

  @override
  Widget build(BuildContext context) {
    if (isAttende(context, event)) {
      return ElevatedButton.icon(
        onPressed: removeAttende,
        icon: const Icon(AkarIcons.cross),
        label: Text(AppLocalizations.of(context)!.cancel_participation),
      );
    }
    return ElevatedButton(
      onPressed: addAttende,
      child: Text(AppLocalizations.of(context)!.participate),
    );
  }
}
