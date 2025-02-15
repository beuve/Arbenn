import 'package:arbenn/data/event/event_data.dart';
import 'package:arbenn/data/user/user_data.dart';
import 'package:arbenn/pages/event/body/_attende_list.dart';
import 'package:arbenn/pages/event/body/_description.dart';
import 'package:arbenn/pages/event/body/_location.dart';
import 'package:arbenn/pages/event/body/_particiapte_button.dart';
import 'package:arbenn/pages/event/body/title/_title.dart';
import 'package:arbenn/pages/event/_utils.dart';
import 'package:flutter/material.dart';

class EventPageBody extends StatelessWidget {
  final EventData event;
  final UserData currentUser;
  final Function() addAttende;
  final Function() removeAttende;
  final Function(EventData) setEvent;
  final bool showTitle;

  const EventPageBody({
    super.key,
    required this.event,
    required this.currentUser,
    required this.addAttende,
    required this.removeAttende,
    required this.setEvent,
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EventPageTitle(
            event: event,
            currentUser: currentUser,
            setEvent: setEvent,
            showTitle: showTitle,
          ),
          if (event.description != '') ...[
            const SizedBox(height: 30),
            EventPageDescription(event: event)
          ],
          if (!isAdmin(context, event)) ...[
            const SizedBox(height: 20),
            EventPageParticipateButton(
              event: event,
              addAttende: addAttende,
              removeAttende: removeAttende,
            )
          ],
          const SizedBox(height: 30),
          EventPageLocation(event: event),
          const SizedBox(height: 30),
          EventPageAttendeList(event: event),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
