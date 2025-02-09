import 'dart:convert';

import 'package:arbenn/data/api.dart';
import 'package:arbenn/data/locations_data.dart';
import 'package:arbenn/data/storage.dart';
import 'package:arbenn/data/tags_data.dart';
import 'package:arbenn/utils/errors/result.dart';
import 'package:flutter/material.dart';
import 'package:arbenn/data/user/authentication.dart';

class UserSumarryData {
  final int userId;
  final String firstName;
  String? pictureUrl;

  UserSumarryData(
      {required this.userId, required this.firstName, this.pictureUrl});

  Map<String, dynamic> toJson() {
    return {"userId": userId, "firstName": firstName};
  }

  static UserSumarryData ofJson(Map<String, dynamic> infos) {
    return UserSumarryData(
        firstName: infos["firstName"], userId: infos["userId"]);
  }

  Future<void> getPicture({required Credentials creds}) async {
    pictureUrl =
        await getProfileUrl("$userId", "tiny", creds: creds).toOption();
  }

  Future<Result<String>> getPictureUrl({required Credentials creds}) async {
    return getProfileUrl("$userId", "tiny", creds: creds);
  }

  static Future<Result<UserSumarryData>> loadFromUserId(int userId,
      {required Credentials creds}) async {
    return Api.get("/u/getUserSumarryData/$userId", creds: creds)
        .map((infos) => jsonDecode(infos))
        .map((json) => ofJson(json));
  }
}

class UserData {
  final int userId;
  final String firstName;
  final String lastName;
  final List<TagData> tags;
  final DateTime birth;
  final City location;
  final String? phone;
  final String description;
  String? pictureUrl;

  UserData({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.tags,
    required this.birth,
    required this.location,
    required this.description,
    this.phone,
    this.pictureUrl,
  });

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

  UserSumarryData summary() {
    return UserSumarryData(
      userId: userId,
      firstName: firstName,
      pictureUrl: pictureUrl,
    );
  }

  @override
  String toString() {
    return toJson().toString();
  }

  Future<Result<String>> getPictureUrl({required Credentials creds}) async {
    return getProfileUrl("$userId", "regular", creds: creds);
  }

  Future<void> loadPicture({required Credentials creds}) async {
    pictureUrl = await getPictureUrl(creds: creds).toOption();
  }

  Map<String, dynamic> toJson() {
    return {
      "userid": userId,
      "first_name": firstName,
      "last_name": lastName,
      "birth": birth.toIso8601String().split("T")[0],
      "city": location.city,
      "city_code": location.cityCode,
      "lon": location.lon,
      "lat": location.lat,
      "bio": description,
      "phone": phone,
      "tags": tags.map((t) => t.id).toList(),
    };
  }

  static Future<Result<UserData>> ofJson(Map<String, dynamic> u,
      {required Credentials creds}) async {
    List<TagData> tags = (u['tags'] as List<dynamic>)
        .map((t) => TagData(id: t["id"], label: t["name"]))
        .toList();
    UserData res = UserData(
        userId: u['userid'],
        firstName: u['first_name'],
        lastName: u['last_name'],
        tags: tags,
        birth: DateTime.parse(u['birth']),
        location: City.ofMap(u),
        phone: u['phone'],
        description: u['bio']);
    await res.loadPicture(creds: creds);
    return Ok(res);
  }

  static Future<Result<UserData>> loadFromUserId(int userId,
      {required Credentials creds}) async {
    return Api.get("/u/getUserData/$userId", creds: creds)
        .map((infos) => jsonDecode(infos))
        .futureBind((json) => ofJson(json, creds: creds));
  }

  Future<Result<UserData>> save({required Credentials creds}) async {
    return Api.post("/u/setUserData", creds: creds, body: toJson())
        .map((_) => this);
  }
}

class UserDataNotifier extends ChangeNotifier {
  UserData _ud;

  UserDataNotifier(UserData ud) : _ud = ud;

  int get userId => _ud.userId;

  set value(UserData newUserData) {
    _ud = newUserData;
    notifyListeners();
  }

  UserData get value => _ud;
}
