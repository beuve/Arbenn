import 'package:flutter/material.dart';
import 'user_data.dart';

class EventSumarryData {
  final String title;
  final int eventId;
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
    int eventid = 1,
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
