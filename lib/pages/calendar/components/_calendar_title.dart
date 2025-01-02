import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalendarTitle extends StatelessWidget {
  const CalendarTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.calendar,
            style: const TextStyle(fontSize: 35, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
