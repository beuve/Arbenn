import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:arbenn/data/event/event_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventPageLocation extends StatelessWidget {
  final EventData event;

  const EventPageLocation({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.location,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        const Image(image: AssetImage('assets/images/placeholder-map.png')),
        const SizedBox(height: 10),
        RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                child: Icon(
                  AkarIcons.location,
                  color: Colors.blue[900],
                  size: 18,
                ),
              ),
              const TextSpan(text: " ", style: TextStyle(fontSize: 20)),
              TextSpan(
                  text: event.address.toString(),
                  style: const TextStyle(color: Colors.black))
            ],
          ),
        )
      ],
    );
  }
}
