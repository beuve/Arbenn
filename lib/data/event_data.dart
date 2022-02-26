import 'package:arbenn/data/storage.dart';
import 'package:flutter/material.dart';
import 'user_data.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';

class EventDataSummary {
  final String eventId;
  final String title;
  final List<String> tags;
  final DateTime date;
  final String location;
  final UserSumarryData admin;
  final int numAttendes;
  final int? maxAttendes;
  final IconData icon;

  const EventDataSummary({
    required this.eventId,
    required this.title,
    required this.tags,
    required this.date,
    required this.location,
    required this.admin,
    required this.numAttendes,
    required this.icon,
    this.maxAttendes,
  });

  static EventDataSummary dummy({
    String eventId = "1",
    String title = "Sport",
    List<String> tags = const ["sport", "running"],
    String location = "Saint Sauveur Lendelin",
    IconData icon = Icons.sports_handball,
    UserSumarryData? admin,
    DateTime? date,
    int numAttendes = 30,
    int maxAttendes = 50,
  }) {
    return EventDataSummary(
      eventId: eventId,
      title: title,
      tags: tags,
      date: date ?? DateTime.now(),
      location: location,
      admin: admin ?? UserSumarryData.dummy(),
      numAttendes: numAttendes,
      maxAttendes: maxAttendes,
      icon: icon,
    );
  }

  static Future<EventDataSummary> ofJson(eventId, infos) async {
    UserSumarryData admin = UserSumarryData.fromJson(infos["admin"]);
    await admin.getPicture();
    return EventDataSummary(
      eventId: eventId,
      icon: Icons.sports_handball,
      admin: admin,
      title: infos["title"],
      tags: infos["tags"].cast<String>() as List<String>,
      date: DateTime.fromMillisecondsSinceEpoch(
          infos["date"].millisecondsSinceEpoch),
      location: infos["location"],
      maxAttendes: infos["maxAttendes"],
      numAttendes: infos["numAttendes"],
    );
  }

  static Future<List<EventDataSummary>> loadAllEvents() async {
    return FirebaseFirestore.instance.collection('events').get().then(
        (value) async =>
            Future.wait(value.docs.map((doc) => ofJson(doc.id, doc.data()))));
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
}

class EventData {
  final String eventId;
  String title;
  List<String> tags;
  DateTime date;
  String location;
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
    required this.location,
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

  static Future<EventData> saveNew({
    required String title,
    required List<String> tags,
    required DateTime date,
    required String location,
    required UserSumarryData admin,
    required String description,
    int? maxAttendes,
  }) async {
    Map<String, dynamic> json = {
      "title": title,
      "date": date,
      "description": description,
      "tags": tags,
      "location": location,
      "admin": admin.toJson(),
      "adminId": admin.userId,
      "maxAttendes": maxAttendes,
      "numAttendes": 1,
      "attendes": [admin],
      "attendesId": [admin.userId]
    };
    CollectionReference users = FirebaseFirestore.instance.collection('events');
    DocumentReference event = await users.add(json);
    return EventData.ofJson(event.id, json);
  }

  static Future<EventData> ofJson(eventId, infos) async {
    UserSumarryData admin = UserSumarryData.fromJson(infos["admin"]);
    await admin.getPicture();
    List<UserSumarryData> attendes = (infos["attendes"] as List<dynamic>)
        .map((i) => UserSumarryData.fromJson(i))
        .toList();
    return EventData(
      eventId: eventId,
      icon: Icons.sports_handball,
      admin: admin,
      title: infos["title"],
      tags: infos["tags"].cast<String>() as List<String>,
      date: DateTime.fromMillisecondsSinceEpoch(
          infos["date"].millisecondsSinceEpoch),
      location: infos["location"],
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
      "location": location,
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

  Future<void> save() async {
    CollectionReference users = FirebaseFirestore.instance.collection('events');
    DocumentReference event = users.doc(eventId);
    await event.set(toJson(), SetOptions(merge: true));
  }

  Future<List<CloudImage>> getImages() async {
    firebase_storage.ListResult result = await firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('images')
        .child('eventImages')
        .child(eventId)
        .listAll();
    List<CloudImage> cloudImage = await Future.wait(
        result.items.map((ref) => CloudImage.loadImage(ref)).toList());
    return cloudImage;
  }

  static Future<void> addAttende(String eventId) async {
    UserSumarryData attende = await UserSumarryData.currentUser();

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
    UserSumarryData attende = await UserSumarryData.currentUser();

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
  /// Correspond to the user (for chat with admin and unique user) or the
  /// eventId if the chat is the event chat (with all attendes).
  final String eventId;
  late Stream<EventData> event;

  EventDataStream({required this.eventId}) {
    event = FirebaseFirestore.instance
        .collection('events')
        .doc(eventId) // make it variable in the future
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
