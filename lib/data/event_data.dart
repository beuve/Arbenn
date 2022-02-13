import 'package:flutter/material.dart';
import 'user_data.dart';

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
  final int eventId;
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
    required this.eventId,
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
        eventId: 1,
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
}
