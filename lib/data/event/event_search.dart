import 'dart:io';

import 'package:arbenn/data/event/event_data.dart';
import 'package:arbenn/utils/constants.dart';
import 'package:arbenn/utils/errors/exceptions.dart';
import 'package:arbenn/utils/errors/result.dart';
import 'package:typesense/typesense.dart';
import 'dart:developer' as developer;
import 'package:arbenn/data/user/authentication.dart';

final host = InternetAddress.loopbackIPv4.address;
final Configuration typesenseConfiguration = Configuration(
  Constants.typesensePass,
  nodes: {
    Node(
      Protocol.http,
      Constants.typesenseHost,
      port: int.parse(Constants.typesensePort),
    ),
  },
  connectionTimeout: const Duration(seconds: 2),
);

class Search {
  late Client client;

  Search() {
    client = Client(typesenseConfiguration);
  }

  Future<bool> upsert(EventData event) {
    return client
        .collection("events")
        .documents
        .upsert({
          "id": event.eventId.toString(),
          "title": event.title,
          "location": [
            event.address.lat,
            event.address.lon,
          ],
          "date": event.date.millisecondsSinceEpoch,
          "tags": event.tags.map((t) => t.id.toString()).toList(),
        })
        .then((value) => false)
        .onError((error, stackTrace) {
          developer.log(
            "Upsert error for event : $event",
            name: "data/event_search Search.upsert",
            error: error,
          );
          return true;
        });
  }

  Future<Result<()>> update(EventData event) {
    return client
        .collection("events")
        .documents
        .update({
          "id": event.eventId.toString(),
          "title": event.title,
          "location": [
            event.address.lat,
            event.address.lon,
          ],
          "date": event.date.millisecondsSinceEpoch,
          "tags": event.tags.map((t) => t.id.toString()).toList(),
        })
        .then((value) => const Ok(()) as Result<()>)
        .onError((error, stackTrace) =>
            Err(ArbennException("[Search] Update error for event : $event")));
  }

  Future<bool> create(EventData event) {
    return client
        .collection("events")
        .documents
        .create({
          "id": event.eventId.toString(),
          "title": event.title,
          "location": [
            event.address.lat,
            event.address.lon,
          ],
          "date": event.date.millisecondsSinceEpoch,
          "tags": event.tags.map((t) => t.id.toString()).toList(),
        })
        .then((value) => false)
        .onError((error, stackTrace) {
          developer.log(
            "Create error for event : $event",
            name: "data/event_search Search.create",
            error: error,
          );
          return true;
        });
  }

  static Future<Result<List<EventDataSummary>>> _parseInfos(
      Map<String, dynamic> infos,
      {required Credentials creds}) {
    List<String> ids = (infos["hits"] as List<dynamic>)
        .map((eventInfos) => eventInfos["document"]["id"] as String)
        .toList();
    return EventDataSummary.loadFromEventIds(
        ids.map((id) => int.parse(id)).toList(),
        creds: creds);
  }

  Future<Result<List<EventDataSummary>>> search(Map<String, dynamic> query,
      {required Credentials creds}) {
    return client
        .collection("events")
        .documents
        .search(query)
        .then((infos) => _parseInfos(infos, creds: creds))
        .onError((error, stackTrace) {
      developer.log(
        "Search error for query : $query",
        name: "data/event_search Search.search",
        error: error,
      );
      return Err(ArbennException("Search error for query : $query"));
    });
  }
}
