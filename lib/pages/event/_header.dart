import 'package:arbenn/data/event/event_data.dart';
import 'package:flutter/material.dart';

class EventPageHeader extends StatelessWidget {
  final EventData event;
  final String? imageUrl;

  const EventPageHeader({
    super.key,
    required this.event,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.black12),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: event.colors,
          tileMode: TileMode.mirror,
        ),
        image: imageUrl == null
            ? null
            : DecorationImage(
                colorFilter: const ColorFilter.mode(
                  Color(0x30000000),
                  BlendMode.darken,
                ),
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
