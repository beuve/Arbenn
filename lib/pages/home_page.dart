import 'package:flutter/material.dart';
import '../data/event_data.dart';
import '../components/event_summary.dart';
import '../utils/colors.dart';
import '../components/scroller.dart';

class HomePage extends StatelessWidget {
  final List<EventSumarryData> eventsData;
  final Nuance color;

  const HomePage({Key? key, required this.eventsData, this.color = Palette.red})
      : super(key: key);

  static HomePage dummy() {
    return HomePage(
      eventsData: [
        EventSumarryData.dummy(),
        EventSumarryData.dummy(),
        EventSumarryData.dummy(),
        EventSumarryData.dummy(),
        EventSumarryData.dummy(),
        EventSumarryData.dummy(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScrollList(
      shadowColor: color.darker,
      children:
          eventsData.map((e) => EventSummary(data: e, color: color)).toList(),
    );
  }
}
