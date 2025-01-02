import 'package:arbenn/data/event/event_data.dart';
import 'package:arbenn/data/storage.dart';
import 'package:arbenn/data/user/user_data.dart';
import 'package:arbenn/pages/event/event_page.dart';
import 'package:arbenn/pages/event/_event_page_placeholder.dart';
import 'package:arbenn/data/user/authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FutureEventPage extends StatelessWidget {
  final EventDataSummary eventSummary;
  final Future<EventData?> event;
  final UserData currentUser;
  final Function() onEdit;

  const FutureEventPage({
    super.key,
    required this.event,
    required this.onEdit,
    required this.eventSummary,
    required this.currentUser,
  });

  @override
  build(BuildContext context) {
    final creds =
        Provider.of<CredentialsNotifier>(context, listen: false).value!;
    final imageUrl = getEventImageUrl(eventSummary.eventId, creds: creds);
    return FutureBuilder(
        future: Future.wait([event, imageUrl]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return EventPage(
              event: (snapshot.data as List<dynamic>)[0] as EventData,
              currentUser: currentUser,
              onEdit: onEdit,
              imageUrl: (snapshot.data as List<dynamic>)[1] as String?,
            );
          } else if (snapshot.hasError) {
            return const Text("error");
          } else {
            return EventPagePlaceholder(
              event: eventSummary,
            );
          }
        });
  }
}
