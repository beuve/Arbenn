import 'package:arbenn/data/storage.dart';
import 'package:flutter/material.dart';
import 'user_data.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EventSumarryData {
  final String title;
  final String eventId;
  final List<String> tags;
  final DateTime date;
  final String location;
  final IconData icon;
  final UserSumarryData admin;
  final int numAttendes;
  final int? maxAttendes;

  const EventSumarryData({
    required this.eventId,
    required this.title,
    required this.tags,
    required this.date,
    required this.location,
    required this.icon,
    required this.admin,
    required this.numAttendes,
    this.maxAttendes,
  });

  static EventSumarryData dummy({
    String eventid = "1",
    String title = "Sport",
    List<String> tags = const ["sport", "running"],
    String location = "Saint Sauveur Lendelin",
    IconData icon = Icons.sports_handball,
    UserSumarryData? admin,
    DateTime? date,
    int numAttendes = 30,
    int maxAttendes = 50,
  }) {
    return EventSumarryData(
      eventId: eventid,
      title: title,
      tags: tags,
      date: date ?? DateTime.now(),
      location: location,
      icon: icon,
      admin: admin ?? UserSumarryData.dummy(),
      numAttendes: numAttendes,
      maxAttendes: maxAttendes,
    );
  }
}

class EventData {
  String? eventId;
  final String title;
  final List<String> tags;
  final DateTime date;
  final String location;
  final UserSumarryData admin;
  final String description;
  final int numAttendes;
  final int? maxAttendes;
  List<UserSumarryData> attendes;

  EventData({
    this.eventId,
    required this.title,
    required this.tags,
    required this.date,
    required this.location,
    required this.admin,
    required this.description,
    required this.numAttendes,
    this.maxAttendes,
    this.attendes = const [],
  });

  static EventData dummy() {
    return EventData(
        eventId: "1",
        title: "Sport",
        tags: ["sport", "running"],
        date: DateTime.now(),
        location: "Saint Sauveur Lendelin",
        admin: UserSumarryData.dummy(),
        numAttendes: 3,
        maxAttendes: 5,
        description:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
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
      await admin.getPicture();
      return EventData(
          eventId: eventId,
          admin: admin,
          title: infos["title"],
          tags: infos["tags"].cast<String>() as List<String>,
          date: DateTime.fromMillisecondsSinceEpoch(
              infos["date"].millisecondsSinceEpoch),
          location: infos["location"],
          maxAttendes: infos["maxAttendes"],
          numAttendes: infos["numAttendes"],
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
    } else {
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
  }
}
