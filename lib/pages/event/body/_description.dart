import 'package:arbenn/data/event/event_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventPageDescription extends StatelessWidget {
  final EventData event;

  const EventPageDescription({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.about_activity,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          event.description,
          textAlign: TextAlign.justify,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        )
      ],
    );
  }
}
