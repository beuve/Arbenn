import 'package:arbenn/data/locations_data.dart';
import 'package:arbenn/data/storage.dart';
import 'package:arbenn/data/tags_data.dart';
import 'package:flutter/material.dart';
import 'user_data.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EventDataSummary {
  final String eventId;
  final String title;
  final List<TagData> tags;
  final DateTime date;
  final Address address;
  final UserSumarryData admin;
  final int numAttendes;
  final int? maxAttendes;
  final String iconUrl;

  const EventDataSummary({
    required this.eventId,
    required this.title,
    required this.tags,
    required this.date,
    required this.address,
    required this.admin,
    required this.numAttendes,
    required this.iconUrl,
    this.maxAttendes,
  });

  static EventDataSummary dummy({
    String eventId = "1",
    String title = "Sport",
    List<TagData>? tags,
    UserSumarryData? admin,
    DateTime? date,
    int numAttendes = 30,
    int maxAttendes = 50,
  }) {
    return EventDataSummary(
      eventId: eventId,
      title: title,
      tags: tags ??
          [
            TagData(label: "sport", id: "sport"),
            TagData(label: "randonnee", id: "hiking")
          ],
      date: date ?? DateTime.now(),
      address: const Address(
        city: "Saint Sauveur Lendelin",
        cityCode: "50490",
        coord: GeoPoint(0, 0),
      ),
      admin: admin ?? UserSumarryData.dummy(),
      numAttendes: numAttendes,
      maxAttendes: maxAttendes,
      iconUrl: "url",
    );
  }

  static Future<EventDataSummary?> ofJson(eventId, infos) async {
    UserSumarryData admin = UserSumarryData.fromJson(infos["admin"]);
    await admin.getPicture();
    List<TagData>? tags =
        await TagData.loadFromIds(infos["tags"].cast<String>() as List<String>);
    if (tags == null) return null;
    String? url = await getIconUrl(tags[0].id);
    if (url == null) throw Exception("Icon url is null");
    return EventDataSummary(
      eventId: eventId,
      admin: admin,
      title: infos["title"],
      tags: tags,
      date: DateTime.fromMillisecondsSinceEpoch(
          infos["date"].millisecondsSinceEpoch),
      address: Address.ofJson(infos["address"]),
      maxAttendes: infos["maxAttendes"],
      numAttendes: infos["numAttendes"],
      iconUrl: url,
    );
  }

  static Future<EventDataSummary?> loadFromEventId(String eventId) async {
    CollectionReference users = FirebaseFirestore.instance.collection('events');

    Map<String, dynamic>? infos = await users
        .doc(eventId)
        .get()
        .then((doc) => doc.data() as Map<String, dynamic>?);
    if (infos == null) {
      return null;
    } else {
      return ofJson(eventId, infos);
    }
  }

  static Future<List<EventDataSummary>?> ofJsons(
      List<Map<String, dynamic>> infos) async {
    if (infos.isEmpty) return [];
    final List<TagData>? tagIds = await TagData.loadFromIds(infos
        .map((e) => e["tags"] as List<dynamic>)
        .expand((i) => i)
        .toSet()
        .toList()
        .cast<String>());
    if (tagIds == null) return null;
    final Map<String, TagData> tagsMap =
        Map<String, TagData>.fromIterable(tagIds, key: (e) => e.id);

    List<EventDataSummary> eventsSummaries = [];
    for (var i = 0; i < infos.length; i++) {
      UserSumarryData admin = UserSumarryData.fromJson(infos[i]["admin"]);
      await admin.getPicture();
      final List<TagData> tags =
          infos[i]["tags"].map<TagData>((t) => tagsMap[t]!).toList();
      String? url = await getIconUrl(tags[0].id);
      if (url == null) return null;
      eventsSummaries.add(EventDataSummary(
        eventId: infos[i]["eventId"],
        admin: admin,
        title: infos[i]["title"],
        tags: tags,
        date: DateTime.fromMillisecondsSinceEpoch(
            infos[i]["date"].millisecondsSinceEpoch),
        address: Address.ofJson(infos[i]["address"]),
        maxAttendes: infos[i]["maxAttendes"],
        numAttendes: infos[i]["numAttendes"],
        iconUrl: url,
      ));
    }
    return eventsSummaries;
  }

  // Need optimisation with a ofJsons
  static Future<List<EventDataSummary>?> loadFromEventIds(
      List<String> eventIds) async {
    if (eventIds.isEmpty) return [];

    CollectionReference users = FirebaseFirestore.instance.collection('events');
    List<Map<String, dynamic>> infos = await users
        .where(FieldPath.documentId, whereIn: eventIds)
        .get()
        .then((doc) => doc.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              data["eventId"] = doc.id;
              return data;
            }).toList());
    return ofJsons(infos);
  }
}

class EventData {
  final String eventId;
  String title;
  List<TagData> tags;
  DateTime date;
  Address address;
  UserSumarryData admin;
  String description;
  int numAttendes;
  int? maxAttendes;
  IconData icon;
  List<UserSumarryData> attendes;

  EventData({
    required this.eventId,
    required this.title,
    required this.tags,
    required this.date,
    required this.address,
    required this.admin,
    required this.description,
    required this.numAttendes,
    required this.icon,
    this.maxAttendes,
    this.attendes = const [],
  });

  @override
  String toString() {
    return toJson().toString();
  }

  static Future<EventData?> saveNew({
    required String title,
    required List<TagData> tags,
    required DateTime date,
    required Address address,
    required UserSumarryData admin,
    required String description,
    int? maxAttendes,
  }) async {
    Map<String, dynamic> json = {
      "title": title,
      "date": date,
      "description": description,
      "tags": tags.map((t) => t.id).toList(),
      "address": address.toJson(),
      "admin": admin.toJson(),
      "adminId": admin.userId,
      "maxAttendes": maxAttendes,
      "numAttendes": 1,
      "attendes": [admin.toJson()],
      "attendesId": [admin.userId]
    };
    CollectionReference users = FirebaseFirestore.instance.collection('events');
    DocumentReference? event =
        await (users.add(json) as Future<DocumentReference?>)
            .onError((error, stackTrace) => null);
    if (event == null) return null;
    return EventData.ofJson(event.id, json);
  }

  static Future<EventData?> ofJson(eventId, infos) async {
    UserSumarryData admin = UserSumarryData.fromJson(infos["admin"]);
    await admin.getPicture();
    List<UserSumarryData> attendes = (infos["attendes"] as List<dynamic>)
        .map((i) => UserSumarryData.fromJson(i))
        .toList();
    List<TagData>? tags =
        await TagData.loadFromIds(infos["tags"].cast<String>() as List<String>);
    if (tags == null) return null;
    return EventData(
      eventId: eventId,
      icon: Icons.sports_handball,
      admin: admin,
      title: infos["title"],
      tags: tags,
      date: DateTime.fromMillisecondsSinceEpoch(
          infos["date"].millisecondsSinceEpoch),
      address: Address.ofJson(infos["address"]),
      maxAttendes: infos["maxAttendes"],
      numAttendes: infos["numAttendes"],
      description: infos["description"],
      attendes: attendes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "date": date,
      "description": description,
      "tags": tags,
      "address": address,
      "admin": admin.toJson(),
      "adminId": admin.userId,
      "attendes": attendes,
      "attendesId": attendes.map((a) => a.userId),
      "maxAttendes": maxAttendes,
      "numAttendes": numAttendes,
    };
  }

  static Future<EventData?> loadFromEventId(String eventId) async {
    CollectionReference users = FirebaseFirestore.instance.collection('events');
    Map<String, dynamic>? infos = await users
        .doc(eventId)
        .get()
        .then((doc) => doc.data() as Map<String, dynamic>?);
    if (infos == null) {
      return null;
    } else {
      return ofJson(eventId, infos);
    }
  }

  Future<bool> save() async {
    CollectionReference users = FirebaseFirestore.instance.collection('events');
    DocumentReference event = users.doc(eventId);
    bool res = await event
        .set(toJson(), SetOptions(merge: true))
        .then((_) => false)
        .onError((error, stackTrace) => true);
    return res;
  }

  Future<List<CloudImage>> getImages() async {
    firebase_storage.ListResult result = await firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('images')
        .child('eventImages')
        .child(eventId)
        .listAll();
    List<CloudImage> cloudImages = await Future.wait(
        result.items.map((ref) => CloudImage.loadImage(ref)).toList());
    return cloudImages;
  }

  static Future<void> addAttende(String eventId) async {
    UserSumarryData attende = UserSumarryData.currentUser();

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('events').doc(eventId);

    return FirebaseFirestore.instance.runTransaction<void>((transaction) async {
      // Get the document
      DocumentSnapshot snapshot = await transaction.get(documentReference);

      if (!snapshot.exists) {
        throw Exception("User does not exist!");
      }

      Map<String, dynamic> infos = snapshot.data()! as Map<String, dynamic>;
      List<String> attendesId = infos['attendesId'].cast<String>();
      List<dynamic> attendes = infos['attendes'] as List<dynamic>;
      int numAttendes = infos['numAttendes'];

      if (!attendesId.any((id) => id == attende.userId)) {
        transaction.update(documentReference, {
          'numAttendes': numAttendes + 1,
          'attendes': [attende.toJson(), ...attendes],
          'attendesId': [attende.userId, ...attendesId],
        });
      }
    });
  }

  static Future<void> removeAttende(String eventId) async {
    UserSumarryData attende = UserSumarryData.currentUser();

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('events').doc(eventId);

    return FirebaseFirestore.instance.runTransaction<void>((transaction) async {
      // Get the document
      DocumentSnapshot snapshot = await transaction.get(documentReference);

      if (!snapshot.exists) {
        throw Exception("Event does not exist!");
      }

      Map<String, dynamic> infos = snapshot.data()! as Map<String, dynamic>;
      List<String> attendesId = infos['attendesId'].cast<String>();
      List<dynamic> attendes = infos['attendes'] as List<dynamic>;
      int numAttendes = infos['numAttendes'];

      if (attendesId.any((id) => id == attende.userId)) {
        attendes.removeWhere((a) => a["userId"] == attende.userId);
        attendesId.removeWhere((id) => id == attende.userId);
        transaction.update(documentReference, {
          'numAttendes': numAttendes - 1,
          'attendes': attendes,
          'attendesId': attendesId,
        });
      }
    });
  }
}

class EventDataStream {
  final String eventId;
  late Stream<EventData?> event;

  EventDataStream({required this.eventId}) {
    event = FirebaseFirestore.instance
        .collection('events')
        .doc(eventId)
        .snapshots()
        .asyncMap((snapshot) {
      Map<String, dynamic>? infos = snapshot.data();
      if (infos == null) {
        return Future.error('Error EventDataStream');
      } else {
        return EventData.ofJson(eventId, infos);
      }
    });
  }
}
