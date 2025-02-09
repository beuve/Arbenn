import 'package:arbenn/components/event_summary.dart';
import 'package:arbenn/data/event/event_data.dart';
import 'package:arbenn/utils/errors/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePageAttendedEvents extends StatelessWidget {
  final Future<Result<List<EventDataSummary>>> events;

  const ProfilePageAttendedEvents({
    super.key,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.events,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            FutureResultEventSummary(events: events)
          ],
        ));
  }
}
