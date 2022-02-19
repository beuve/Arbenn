import 'package:arbenn/components/event_summary.dart';
import 'package:arbenn/components/tags.dart';
import 'package:arbenn/data/event_data.dart';
import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../data/event_data.dart';
import '../components/scroller.dart';
import '../components/inputs.dart';

class SearchPage extends StatefulWidget {
  final Nuance color;

  const SearchPage({
    Key? key,
    this.color = Palette.green,
  }) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late bool _showSettings;
  late List<EventData> _events;
  final _settingsKey = GlobalKey();
  final _eventsListKey = GlobalKey();

  @override
  void initState() {
    _showSettings = false;
    _events = [
      EventData.dummy(),
      EventData.dummy(),
      EventData.dummy(),
      EventData.dummy(),
      EventData.dummy(),
      EventData.dummy(),
    ];
    super.initState();
  }

  Widget _buildInputArea() {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(10),
            color: Palette.grey.lighter,
            child: TextField(
              autocorrect: false,
              autofocus: true,
              decoration: InputDecoration(
                fillColor: Palette.green.lighter,
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: widget.color.dark)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: widget.color.dark)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: widget.color.dark)),
                contentPadding: const EdgeInsets.all(5),
              ),
              cursorColor: widget.color.dark,
              style: TextStyle(color: widget.color.darker, fontSize: 20),
            ),
          ),
        ),
        TextButton(
          onPressed: () => setState(() => _showSettings = !_showSettings),
          child: Container(
            padding: const EdgeInsets.only(right: 15),
            child: Icon(
              Icons.settings,
              size: 30,
              color: widget.color.darker,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettings() {
    return Expanded(
      key: _settingsKey,
      flex: 10,
      child: Container(
        width: double.infinity,
        color: widget.color.light,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Text(
              "Tags",
              style: TextStyle(
                  color: widget.color.darker,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Tags.static(
              ["sport", "handball"],
              active: true,
              color: widget.color,
            ),
            const SizedBox(height: 30),
            Text(
              "Location",
              style: TextStyle(
                  color: widget.color.darker,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SearchInput(label: "Chercher une addresse...", color: widget.color),
            const SizedBox(height: 30),
            Text(
              "Date",
              style: TextStyle(
                  color: widget.color.darker,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SearchInput(label: "Chercher une date...", color: widget.color),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsList() {
    return Expanded(
      key: _eventsListKey,
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
            color: widget.color.lighter,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(25))),
        child: _showSettings
            ? Container()
            : ScrollList(
                shadowColor: widget.color.darker,
                children: _events
                    .map((e) => EventSummary(data: e, color: widget.color))
                    .toList()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: widget.color.main,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: widget.color.light,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(25))),
        child: Column(
          children: [
            _buildInputArea(),
            if (_showSettings) _buildSettings(),
            _buildEventsList(),
          ],
        ),
      ),
    );
  }
}
