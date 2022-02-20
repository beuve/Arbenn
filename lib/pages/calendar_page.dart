import 'package:arbenn/components/scroller.dart';
import 'package:flutter/material.dart';
import '../data/event_data.dart';
import '../components/event_summary.dart';
import '../utils/colors.dart';
import '../components/tabs.dart';

class CalendarPage extends StatelessWidget {
  final Future<List<EventData>> eventsData;
  final Nuance color;

  const CalendarPage(
      {Key? key, required this.eventsData, this.color = Palette.orange})
      : super(key: key);

  static CalendarPage dummy() {
    return CalendarPage(
      eventsData: (() async => [
            EventData.dummy(date: DateTime.parse("19700101")),
            EventData.dummy(date: DateTime.parse("19700101")),
            EventData.dummy(date: DateTime.parse("19700101")),
            EventData.dummy(date: DateTime.parse("19700101")),
            EventData.dummy(date: DateTime.parse("19700101")),
            EventData.dummy(date: DateTime.parse("20221211")),
            EventData.dummy(date: DateTime.parse("20221212")),
            EventData.dummy(date: DateTime.parse("20221212")),
            EventData.dummy(date: DateTime.parse("20221213")),
            EventData.dummy(date: DateTime.parse("20221214")),
          ])(),
    );
  }

  String _monthFromInt(int m) {
    switch (m) {
      case DateTime.january:
        return "Janvier";
      case DateTime.february:
        return "Fevrier";
      case DateTime.march:
        return "Mars";
      case DateTime.april:
        return "Avril";
      case DateTime.may:
        return "Mai";
      case DateTime.june:
        return "June";
      case DateTime.july:
        return "Juillet";
      case DateTime.august:
        return "Aout";
      case DateTime.september:
        return "Septembre";
      case DateTime.october:
        return "Octobre";
      case DateTime.november:
        return "Novembre";
      default:
        return "Décembre";
    }
  }

  String _weekDayFromInt(int d) {
    switch (d) {
      case DateTime.monday:
        return "Lundi";
      case DateTime.tuesday:
        return "Mardi";
      case DateTime.wednesday:
        return "Mercredi";
      case DateTime.thursday:
        return "Jeudi";
      case DateTime.friday:
        return "Vendredi";
      case DateTime.saturday:
        return "Samedi";
      default:
        return "Dimanche";
    }
  }

  Widget _buildDateSeparator(DateTime date) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          Text(
            '${_weekDayFromInt(date.weekday)} ${date.day} ${_monthFromInt(date.month)}',
            style: TextStyle(color: color.main, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 5),
          Expanded(
              child: Divider(
            color: color.main,
            thickness: 1,
          ))
        ],
      ),
    );
  }

  List<Widget> _buildFuturWidgetList(List<EventData> events) {
    DateTime? prev;
    List<Widget> res = [];
    for (var i = 0; i < events.length; i++) {
      if (prev == null ||
          events[i].date.day != prev.day ||
          events[i].date.month != prev.month ||
          events[i].date.year != prev.year) {
        prev = events[i].date;
        res.add(_buildDateSeparator(events[i].date));
      }
      res.add(EventSummary(data: events[i], color: color));
    }
    return res;
  }

  TabInfos _buildSingleTab(String title, List<Widget> events) {
    return TabInfos(
        content: ScrollList(
          shadowColor: color.darker,
          children: events,
        ),
        title: title);
  }

  List<TabInfos> _buildTabs(List<EventData> events) {
    final List<EventData> past =
        events.where((e) => e.date.isBefore(DateTime.now())).toList();
    final List<EventData> future =
        events.where((e) => e.date.isAfter(DateTime.now())).toList();
    return [
      _buildSingleTab("Passé(s)",
          past.map((e) => EventSummary(data: e, color: color)).toList()),
      _buildSingleTab("Futur(s)", _buildFuturWidgetList(future))
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.main,
      child: FutureBuilder(
          future: eventsData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Tabs(
                tabs: _buildTabs(snapshot.data as List<EventData>),
                color: color,
                startingTab: 1,
              );
            } else {
              return Tabs(
                tabs: [
                  _buildSingleTab("Passé(s)", []),
                  _buildSingleTab("Futur(s)", [])
                ],
                color: color,
                startingTab: 1,
              );
            }
          }),
    );
  }
}
