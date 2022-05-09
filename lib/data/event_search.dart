import 'dart:io';

import 'package:arbenn/data/event_data.dart';
import 'package:typesense/typesense.dart';
import 'dart:developer' as developer;

final host = InternetAddress.loopbackIPv4.address;
final Configuration typesenseConfiguration = Configuration(
  'xyz',
  nodes: {
    Node(
      Protocol.http, // For Typesense Cloud use https
      "10.0.2.2", // For Typesense Cloud use xxx.a1.typesense.net
      port: 8108, // For Typesense Cloud use 443
    ),
  },
  connectionTimeout: const Duration(seconds: 2),
);

class SearchQuery {}

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
          "id": event.eventId,
          "title": event.title,
          "location": [
            event.address.coord.latitude,
            event.address.coord.longitude,
          ],
          "date": event.date.millisecondsSinceEpoch,
          "tags": event.tags.map((t) => t.id).toList(),
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

  Future<bool> update(EventData event) {
    return client
        .collection("events")
        .documents
        .update({
          "id": event.eventId,
          "title": event.title,
          "location": [
            event.address.coord.latitude,
            event.address.coord.longitude,
          ],
          "date": event.date.millisecondsSinceEpoch,
          "tags": event.tags.map((t) => t.id).toList(),
        })
        .then((value) => false)
        .onError((error, stackTrace) {
          developer.log(
            "Update error for event : $event",
            name: "data/event_search Search.update",
            error: error,
          );
          return true;
        });
  }

  Future<bool> create(EventData event) {
    return client
        .collection("events")
        .documents
        .create({
          "id": event.eventId,
          "title": event.title,
          "location": [
            event.address.coord.latitude,
            event.address.coord.longitude,
          ],
          "date": event.date.millisecondsSinceEpoch,
          "tags": event.tags.map((t) => t.id).toList(),
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

  static Future<List<EventDataSummary>?> _parseInfos(
      Map<String, dynamic> infos) {
    List<String> ids = (infos["hits"] as List<dynamic>)
        .map((eventInfos) => eventInfos["document"]["id"] as String)
        .toList();
    return EventDataSummary.loadFromEventIds(ids);
  }

  Future<List<EventDataSummary>?> search(Map<String, dynamic> query) {
    return client
        .collection("events")
        .documents
        .search(query)
        .then(_parseInfos)
        .onError((error, stackTrace) {
      developer.log(
        "Search error for query : $query",
        name: "data/event_search Search.search",
        error: error,
      );
      return null;
    });
  }
}
