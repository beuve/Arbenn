import 'package:flutter/material.dart';
import '../data/event_data.dart';
import '../components/event_summary.dart';
import '../utils/colors.dart';
import '../components/scroller.dart';

class HomePage extends StatefulWidget {
  final Nuance color;

  const HomePage({Key? key, this.color = Palette.red}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<EventDataSummary> _events = [];

  @override
  void initState() {
    super.initState();
    initInfos();
  }

  void initInfos() async {
    List<EventDataSummary> allEvents = await EventDataSummary.loadAllEvents();
    setState(() {
      _events = allEvents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScrollList(
      shadowColor: widget.color.darker,
      children: _events
          .map((e) => EventSummary(data: e, color: widget.color))
          .toList(),
    );
  }
}
