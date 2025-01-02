import 'package:arbenn/components/event_summary.dart';
import 'package:arbenn/components/location_search/address_search/address_search.dart';
import 'package:arbenn/pages/search/_search_area.dart';
import 'package:arbenn/pages/search/_show_settings.dart';
import 'package:arbenn/utils/page_transitions.dart';
import 'package:arbenn/components/tags.dart';
import 'package:arbenn/data/event/event_data.dart';
import 'package:arbenn/data/event/event_search.dart';
import 'package:arbenn/data/locations_data.dart';
import 'package:arbenn/data/tags_data.dart';
import 'package:arbenn/data/user/user_data.dart';
import 'package:flutter/material.dart';
import 'package:arbenn/components/inputs.dart';
import 'package:provider/provider.dart';
import 'package:arbenn/data/user/authentication.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
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
    _events = Future.value([]);
    _tags = [];
    _address = null;
    _locked = false;
    _searchText.addListener(() {
      _runSearch();
    });
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
        initTags: _tags,
        onFinish: (tags) {
          Navigator.of(context).pop();
          setState(
            () => _tags = tags,
          );
          Navigator.of(context).pop();
          _showSettings(); // Needed to update the tags in bottomSheet
        })));
  }

  void _showSettings() {
    showSettings(
      context,
      updateTags: updateTags,
      updateAddress: updateAddress,
      runSearch: _runSearch,
      tags: _tags,
      addressController: _addressController,
      dateRangeController: _dateRangeController,
    );
  }

  void updateAddress() {
    Navigator.of(context).push(slideIn(SearchAddress(onFinish: (address) {
      setState(() => _address = address);
      _addressController.text = _address!.toString();
    })));
  }

  void _runSearch() async {
    if (!_locked) {
      final creds =
          Provider.of<CredentialsNotifier>(context, listen: false).value!;
      UserData user =
          Provider.of<UserDataNotifier>(context, listen: false).value;
      _locked = true;
      await Future.delayed(const Duration(milliseconds: 300));
      final String textQuery = _searchText.text != "" ? _searchText.text : "*";
      final double userLon = user.location.lon;
      final double userLat = user.location.lat;
      final String tagsFilter = _tags.isNotEmpty
          ? "&& tags: [${_tags.map((t) => t.id).join(",")}]"
          : "";
      final String locationFilter =
          "location:(${_address?.lon ?? userLat}, ${_address?.lat ?? userLon}, 20 km)";
      final Map<String, dynamic> query = {
        'q': textQuery,
        'query_by': 'title',
        'filter_by': "$locationFilter$tagsFilter",
        'sort_by':
            'location(${_address?.lon ?? userLat}, ${_address?.lat ?? userLon}):asc'
      };
      _events = Search().search(query, creds: creds);
      setState(() => {});
      _locked = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureOptionEventSummaryView(
      events: _events,
      header: SearchArea(
        searchText: _searchText,
        showSettings: _showSettings,
      ),
      emptyText:
          "Aucun évenement correspondent à tes critères de recherche n'a été trouvé, mais pas de panique, tu peux créer le tiens !",
    );
  }
}
