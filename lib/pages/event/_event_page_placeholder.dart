import 'package:arbenn/data/event/event_data.dart';
import 'package:flutter/material.dart';

class EventPagePlaceholder extends StatelessWidget {
  final EventDataSummary event;

  const EventPagePlaceholder({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      bottom: false,
      child: Scaffold(
        body: Text("Placeholder"),
      ),
    );
  }
}
