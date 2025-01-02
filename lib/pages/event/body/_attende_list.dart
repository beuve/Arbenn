import 'package:arbenn/data/event/event_data.dart';
import 'package:arbenn/pages/event/body/_attende.dart';
import 'package:arbenn/data/user/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class EventPageAttendeList extends StatelessWidget {
  final EventData event;

  const EventPageAttendeList({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final creds =
        Provider.of<CredentialsNotifier>(context, listen: false).value!;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "${AppLocalizations.of(context)!.attendes} · ${event.numAttendes}",
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      if (event.maxAttendes != null)
        Text(
          "${event.maxAttendes! - event.numAttendes} places restantes",
          style: const TextStyle(fontSize: 12, color: Colors.black45),
        ),
      ...event.attendes.map((a) => Attende(user: a, event: event, creds: creds))
    ]);
  }
}
