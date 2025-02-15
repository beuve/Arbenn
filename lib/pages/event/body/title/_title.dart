import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:arbenn/components/buttons.dart';
import 'package:arbenn/components/tags.dart';
import 'package:arbenn/data/event/event_data.dart';
import 'package:arbenn/data/user/user_data.dart';
import 'package:arbenn/pages/forms/event_form/event_form.dart';
import 'package:arbenn/pages/event/body/title/_date_and_attende.dart';
import 'package:arbenn/pages/event/_utils.dart';
import 'package:flutter/material.dart';

class EventPageTitle extends StatelessWidget {
  final EventData event;
  final UserData currentUser;
  final Function(EventData) setEvent;
  final bool showTitle;

  const EventPageTitle({
    super.key,
    required this.event,
    required this.currentUser,
    required this.setEvent,
    required this.showTitle,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        if (isAdmin(context, event))
          Container(
            margin: const EdgeInsets.only(top: 10),
            alignment: Alignment.topRight,
            child: SquareButton(
              icon: AkarIcons.edit,
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventFormPage(
                      admin: currentUser,
                      event: event,
                    ),
                  ),
                ).then((ev) {
                  if (ev != null) setEvent(ev);
                });
              },
            ),
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showTitle)
              SizedBox(
                width: width - 90, // Avoid collision with edit button
                child: Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (!showTitle)
              const SizedBox(
                height: 15,
              ),
            const SizedBox(height: 4),
            DateAndAttendes(event: event),
            const SizedBox(height: 10),
            StaticTags(event.tags.map((t) => t.label).toList())
          ],
        ),
      ],
    );
  }
}
