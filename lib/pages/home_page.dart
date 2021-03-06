import 'package:flutter/material.dart';
import 'package:arbenn/data/event_data.dart';
import 'package:arbenn/components/event_summary.dart';
import 'package:arbenn/utils/colors.dart';

class HomePage extends StatelessWidget {
  final Nuance color;
  final Future<List<EventDataSummary>?> events;
  final Future<void> Function()? onRefresh;

  const HomePage(
      {Key? key,
      this.color = Palette.red,
      required this.events,
      this.onRefresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: FutureOptionEventSummary(
        onRefresh: onRefresh,
        color: color,
        events: events,
        numPlaceholders: 1,
      ),
    );
  }
}
