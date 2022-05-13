import 'package:arbenn/components/event_summary.dart';
import 'package:arbenn/components/page_transitions.dart';
import 'package:arbenn/components/search_location.dart';
import 'package:arbenn/components/tags.dart';
import 'package:arbenn/data/event_data.dart';
import 'package:arbenn/data/event_search.dart';
import 'package:arbenn/data/locations_data.dart';
import 'package:arbenn/data/tags_data.dart';
import 'package:arbenn/data/user_data.dart';
import 'package:arbenn/utils/icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:arbenn/utils/colors.dart';
import 'package:arbenn/components/inputs.dart';

class SearchPage extends StatefulWidget {
  final Nuance color;
  final UserData currentUser;

  const SearchPage({
    Key? key,
    required this.currentUser,
    this.color = Palette.green,
  }) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  late bool _showSettings;
  late Future<List<EventDataSummary>?> _events;
  late List<TagData> _tags;
  late AnimationController expandController;
  late Animation<double> animation;
  late Address? _address;
  final TextEditingController _searchText = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final DateRangePickingController _dateRangeController =
      DateRangePickingController();
  late bool _locked;

  @override
  void initState() {
    _showSettings = false;
    _events = Future.value([]);
    _tags = [];
    _address = null;
    _locked = false;
    _searchText.addListener(() => _runSearch());
    expandController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
    super.initState();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  void updateTags() {
    Navigator.of(context).push(slideIn(SearchTagsWidget(
        color: widget.color,
        initTags: _tags,
        onFinish: (tags) {
          Navigator.of(context).pop();
          setState(
            () => _tags = tags,
          );
        })));
  }

  void updateAddress() {
    Navigator.of(context).push(slideIn(SearchAddress(
        color: widget.color,
        onFinish: (address) {
          setState(() => _address = address);
          _addressController.text = _address!.toString();
        })));
  }

  void _runExpandCheck() {
    if (_showSettings) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  void _runSearch() async {
    if (!_locked) {
      _locked = true;
      await Future.delayed(const Duration(milliseconds: 300));
      String textQuery = _searchText.text != "" ? _searchText.text : "*";
      GeoPoint coord = _address == null
          ? widget.currentUser.location.coord
          : _address!.coord;
      String tagsFilter = _tags.isNotEmpty
          ? "&& tags:=${_tags.map((t) => t.id).toString()}"
          : "";
      String locationFilter =
          "location:(${coord.latitude}, ${coord.longitude}, 20 km)";
      Map<String, dynamic> query = {
        'q': textQuery,
        'query_by': 'title',
        'filter_by': "$locationFilter$tagsFilter",
        'sort_by': 'location(${coord.latitude}, ${coord.longitude}):asc'
      };
      _events = Search().search(query);
      setState(() => {});
      _locked = false;
    }
  }

  Widget _buildInputArea() {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(10),
            color: Palette.grey.lighter,
            child: TextField(
              controller: _searchText,
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
          onPressed: () {
            setState(() => _showSettings = !_showSettings);
            _runExpandCheck();
            if (!_showSettings) _runSearch();
          },
          child: Container(
            padding: const EdgeInsets.only(right: 15),
            child: Icon(
              _showSettings ? ArbennIcons.chevronUp : ArbennIcons.sliders,
              size: 30,
              color: widget.color.darker,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettings() {
    return SizeTransition(
      axisAlignment: -1.0,
      sizeFactor: animation,
      child: Container(
        color: widget.color.light,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              "Tags",
              style: TextStyle(
                  color: widget.color.darker,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Tags.static(_tags,
                active: true, color: widget.color, addAction: updateTags),
            const SizedBox(height: 30),
            Text(
              "Location",
              style: TextStyle(
                  color: widget.color.darker,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SearchInput(
              label: "Chercher une address...",
              color: widget.color,
              readOnly: true,
              onTap: updateAddress,
              controller: _addressController,
            ),
            const SizedBox(height: 30),
            Text(
              "Date",
              style: TextStyle(
                  color: widget.color.darker,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DateRangePicker(
              context,
              label: "Chercher une date...",
              searchDesign: true,
              color: widget.color,
              controller: _dateRangeController,
              startDate: DateTime(DateTime.now().year - 1),
              stopDate: DateTime(DateTime.now().year + 2),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsList() {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
            color: widget.color.lighter,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(25))),
        child: AnimatedSwitcher(
          duration: const Duration(seconds: 5),
          child: FutureOptionEventSummary(color: widget.color, events: _events),
        ),
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
            _buildSettings(),
            _buildEventsList(),
          ],
        ),
      ),
    );
  }
}
