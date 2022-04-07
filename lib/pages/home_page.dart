import 'package:arbenn/data/event_search.dart';
import 'package:arbenn/data/tags_data.dart';
import 'package:arbenn/data/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../data/event_data.dart';
import '../components/event_summary.dart';
import '../utils/colors.dart';

class HomePage extends StatefulWidget {
  final Nuance color;
  final UserData currentUser;

  const HomePage(
      {Key? key, this.color = Palette.red, required this.currentUser})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<EventDataSummary>?> _events;

  void printSearchResults() async {
    final GeoPoint coord = widget.currentUser.location.coord;
    final List<TagData> tags = widget.currentUser.tags;
    List<EventDataSummary>? events = await Search().search({
      "q": "*",
      'query_by': 'title',
      'sort_by': 'location(${coord.latitude}, ${coord.longitude}):asc',
      'filter_by': "tags:=${tags.map((t) => t.id).toString()}",
    });
    print(events);
  }

  @override
  void initState() {
    super.initState();
    _events = EventDataSummary.loadAllEvents();
    printSearchResults();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: FutureOptionEventSummary(
        color: widget.color,
        events: _events,
        numPlaceholders: 1,
      ),
    );
  }
}
