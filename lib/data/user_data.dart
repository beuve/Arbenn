import 'package:flutter/material.dart';

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
