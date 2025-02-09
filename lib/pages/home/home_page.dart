import 'package:arbenn/data/event/event_data.dart';
import 'package:arbenn/data/event/event_search.dart';
import 'package:arbenn/data/tags_data.dart';
import 'package:arbenn/data/user/user_data.dart';
import 'package:arbenn/pages/home/_home_title.dart';
import 'package:arbenn/utils/errors/result.dart';
import 'package:flutter/material.dart';
import 'package:arbenn/components/event_summary.dart';
import 'package:provider/provider.dart';
import 'package:arbenn/data/user/authentication.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Result<List<EventDataSummary>>> _recommendedEvents;

  @override
  void initState() {
    loadRecommendedEvents();
    super.initState();
  }

  void loadRecommendedEvents() {
    UserData user = Provider.of<UserDataNotifier>(context, listen: false).value;
    final creds =
        Provider.of<CredentialsNotifier>(context, listen: false).value!;
    final double lon = user.location.lon;
    final double lat = user.location.lat;
    final List<TagData> tags = user.tags;

    String printListString(List<String> l) {
      String res = "[";
      for (var i = 0; i < l.length; i++) {
        if (i > 0) res = "$res,";
        res = res + l[i];
      }
      res = "$res]";
      return res;
    }

    setState(() {
      _recommendedEvents = Search().search({
        "q": "*",
        'query_by': 'title',
        'sort_by': 'location($lat, $lon):asc',
        'filter_by':
            "tags:=${printListString(tags.map((t) => t.id.toString()).toList())}",
      }, creds: creds);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureOptionEventSummaryView(
      emptyText:
          "Aucun évenement n'a été trouvé correspondent à tes centres d'intérêts, mais pas de panique, tu peux créer le tiens !",
      onRefresh: () async => loadRecommendedEvents(),
      events: _recommendedEvents,
      numPlaceholders: 1,
      header: const HomeTitle(),
    );
  }
}
