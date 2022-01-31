import 'package:flutter/material.dart';
import 'event_data.dart';

class UserSumarryData {
  final int userId;
  final String firstName;
  final ImageProvider<Object> picture;

  UserSumarryData(
      {required this.userId, required this.firstName, required this.picture});

  static UserSumarryData dummy() {
    const ImageProvider<Object> image =
        AssetImage('assets/images/user_placeholder.png');
    const String name = "john";
    return UserSumarryData(userId: 1, firstName: name, picture: image);
  }
}

class UserData {
  final int userId;
  final String firstName;
  final String lastName;
  final List<String> tags;
  final DateTime birth;
  final String location;
  final String description;
  List<EventSumarryData> events;
  final ImageProvider<Object> picture;

  UserData({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.tags,
    required this.birth,
    required this.location,
    required this.description,
    required this.events,
    required this.picture,
  });

  static UserData dummy({
    int userId = 1,
    String firstName = "John",
    String lastName = "Doe",
    List<String> tags = const ["Sport", "Handball"],
    DateTime? birth,
    String location = "Saint Sauveur Lendelin",
    String description =
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
    List<EventSumarryData>? events,
  }) {
    return UserData(
        userId: userId,
        firstName: firstName,
        lastName: lastName,
        tags: tags,
        birth: DateTime.parse("19951124"),
        location: "Saint Sauveur Lendelin",
        description: description,
        events: events ??
            [
              EventSumarryData.dummy(),
              EventSumarryData.dummy(),
              EventSumarryData.dummy(),
              EventSumarryData.dummy(),
            ],
        picture: const AssetImage('assets/images/user_placeholder.png'));
  }

  int get age {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birth.year;
    int month1 = currentDate.month;
    int month2 = birth.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birth.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }
}
