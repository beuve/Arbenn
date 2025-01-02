import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:arbenn/data/event/event_data.dart';
import 'package:arbenn/utils/date.dart';
import 'package:flutter/material.dart';

class DateAndAttendes extends StatelessWidget {
  final EventData event;

  const DateAndAttendes({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          AkarIcons.calendar,
          size: 15,
          color: Colors.black45,
        ),
        const SizedBox(width: 5),
        Text(
          "${event.date.day} ${monthFromInt(event.date.month)} · ${event.date.hour}:${event.date.minute}",
          style: const TextStyle(fontSize: 14, color: Colors.black45),
        ),
        if (event.maxAttendes != null)
          Text(
            " · ${event.maxAttendes! - event.numAttendes} places restantes",
            style: const TextStyle(fontSize: 12, color: Colors.black45),
          )
      ],
    );
  }
}
