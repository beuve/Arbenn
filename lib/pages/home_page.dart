import 'package:flutter/material.dart';
import '../data/event_data.dart';
import '../components/event_summary.dart';
import '../utils/colors.dart';

class HomePage extends StatefulWidget {
  final Nuance color;

  const HomePage({Key? key, this.color = Palette.red}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<EventDataSummary>?> _events;

  @override
  void initState() {
    super.initState();
    _events = EventDataSummary.loadAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    return FutureOptionEventSummary(
      color: widget.color,
      events: _events,
      numPlaceholders: 1,
    );
  }
}
