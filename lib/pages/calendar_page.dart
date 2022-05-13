import 'package:arbenn/components/scroller.dart';
import 'package:flutter/material.dart';
import 'package:arbenn/data/event_data.dart';
import 'package:arbenn/components/event_summary.dart';
import 'package:arbenn/utils/colors.dart';
import 'package:arbenn/components/tabs.dart';

class CalendarPage extends StatelessWidget {
  final List<EventDataSummary>? futureEvents;
  final List<EventDataSummary>? pastEvents;
  final Nuance color;

  const CalendarPage(
      {Key? key,
      required this.pastEvents,
      required this.futureEvents,
      this.color = Palette.orange})
      : super(key: key);

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
    String year = date.year != DateTime.now().year ? " ${date.year}" : "";
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          Text(
            '${_weekDayFromInt(date.weekday)} ${date.day} ${_monthFromInt(date.month)}$year',
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

  Widget _buildFuturWidgetList(List<EventDataSummary> events) {
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
    return Container(
      margin: const EdgeInsets.all(5),
      child: ScrollList(color: color, children: res),
    );
  }

  TabInfos _buildSingleTab(String title, Widget events) {
    return TabInfos(title: title, content: events);
  }

  List<TabInfos> _buildTabs(
    List<EventDataSummary>? pastEvents,
    List<EventDataSummary>? futurEvents,
  ) {
    return [
      _buildSingleTab(
        "Passé(s)",
        pastEvents == null
            ? EventSummariesPlaceHolders(color: color)
            : EventSummaries(color: color, events: pastEvents),
      ),
      _buildSingleTab(
          "Futur(s)",
          futurEvents == null
              ? EventSummariesPlaceHolders(color: color)
              : _buildFuturWidgetList(futurEvents))
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: color.main,
        child: Tabs(
          tabs: _buildTabs(pastEvents, futureEvents),
          color: color,
          startingTab: 1,
        ));
  }
}
