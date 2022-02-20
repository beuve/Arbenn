import 'package:arbenn/data/storage.dart';
import 'package:flutter/material.dart';
import 'user_data.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EventData {
  String eventId;
  final String title;
  final List<String> tags;
  final DateTime date;
  final String location;
  final UserSumarryData admin;
  final String description;
  final int numAttendes;
  final int? maxAttendes;
  final IconData icon;
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

  static EventData dummy({
    String eventId = "1",
    String title = "Sport",
    List<String> tags = const ["sport", "running"],
    String location = "Saint Sauveur Lendelin",
    IconData icon = Icons.sports_handball,
    UserSumarryData? admin,
    String description =
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
    DateTime? date,
    int numAttendes = 30,
    int maxAttendes = 50,
  }) {
    return EventData(
        eventId: eventId,
        title: title,
        tags: tags,
        date: date ?? DateTime.now(),
        location: location,
        admin: admin ?? UserSumarryData.dummy(),
        numAttendes: numAttendes,
        maxAttendes: maxAttendes,
        description: description,
        icon: icon,
        attendes: [
          UserSumarryData.dummy(),
          UserSumarryData.dummy(),
          UserSumarryData.dummy(),
        ]);
  }

  @override
  String toString() {
    return toJson().toString();
  }

  static EventData ofJson(eventId, infos) {
    UserSumarryData admin = UserSumarryData.fromJson(infos["admin"]);
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
      UserSumarryData admin = UserSumarryData.fromJson(infos["admin"]);
      List<UserSumarryData> attendes =
          (infos["admin"] as List<Map<String, dynamic>>)
              .map((e) => UserSumarryData.fromJson(infos["admin"]))
              .toList();
      await admin.getPicture();
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
          attendes: attendes);
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
}

class EventCreationData {
  String? eventId;
  final String title;
  final List<String> tags;
  final DateTime date;
  final String location;
  final UserSumarryData admin;
  final String description;
  final int numAttendes;
  final int? maxAttendes;
  final IconData icon;
  final List<UserSumarryData> attendes;

  EventCreationData({
    this.eventId,
    required this.title,
    required this.tags,
    required this.date,
    required this.location,
    required this.admin,
    required this.description,
    required this.numAttendes,
    required this.icon,
    required this.attendes,
    this.maxAttendes,
  });

  static Future<EventCreationData?> loadFromEventId(String eventId) async {
    CollectionReference users = FirebaseFirestore.instance.collection('events');

    Map<String, dynamic>? infos = await users
        .doc(eventId)
        .get()
        .then((doc) => doc.data() as Map<String, dynamic>?);
    if (infos == null) {
      return null;
    } else {
      UserSumarryData admin = UserSumarryData.fromJson(infos["admin"]);
      List<UserSumarryData> attendes =
          (infos["admin"] as List<Map<String, dynamic>>)
              .map((e) => UserSumarryData.fromJson(infos["admin"]))
              .toList();
      await admin.getPicture();
      return EventCreationData(
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
          attendes: attendes,
          description: infos["description"]);
    }
  }

  Future<void> save() async {
    CollectionReference users = FirebaseFirestore.instance.collection('events');
    DocumentReference event = users.doc(eventId);
    await event.set(toJson(), SetOptions(merge: true));
    eventId ??= event.id;
  }

  Future<List<CloudImage>> getImages() async {
    if (eventId == null) {
      return [];
    }
    firebase_storage.ListResult result = await firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('images')
        .child('eventImages')
        .child(eventId!)
        .listAll();
    List<CloudImage> cloudImage = await Future.wait(
        result.items.map((ref) => CloudImage.loadImage(ref)).toList());
    return cloudImage;
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "date": date,
      "description": description,
      "tags": tags,
      "location": location,
      "admin": admin.toJson(),
      "adminId":
          admin.userId, // needed for filtering several events of the same user
      "maxAttendes": maxAttendes,
      "numAttendes": numAttendes,
      "attendes": attendes.map((a) => a.toJson()).toList(),
      "attendesId": attendes.map((a) => a.userId).toList(),
    };
  }

  static EventCreationData fromEventData(EventData event) {
    return EventCreationData(
      eventId: event.eventId,
      title: event.title,
      tags: event.tags,
      date: event.date,
      location: event.location,
      admin: event.admin,
      numAttendes: event.numAttendes,
      maxAttendes: event.maxAttendes,
      description: event.description,
      icon: event.icon,
      attendes: event.attendes,
    );
  }

  EventData? toEventData() {
    if (eventId == null) {
      return null;
    } else {
      return EventData(
        eventId: eventId!,
        title: title,
        tags: tags,
        date: date,
        location: location,
        admin: admin,
        numAttendes: numAttendes,
        maxAttendes: maxAttendes,
        description: description,
        icon: icon,
      );
    }
  }
}
