import 'package:arbenn/data/storage.dart';
import 'package:flutter/material.dart';
import 'event_data.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserSumarryData {
  final String userId;
  final String firstName;
  ImageProvider<Object>? picture;

  UserSumarryData(
      {required this.userId, required this.firstName, this.picture});

  static UserSumarryData dummy() {
    const ImageProvider<Object> image =
        AssetImage('assets/images/user_placeholder.png');
    const String name = "john";
    return UserSumarryData(userId: "1", firstName: name, picture: image);
  }

  Map<String, dynamic> toJson() {
    return {"userId": userId, "firstName": firstName};
  }

  static UserSumarryData fromJson(Map<String, dynamic> infos) {
    return UserSumarryData(
        firstName: infos["firstName"], userId: infos["userId"]);
  }

  Future<void> getPicture() async {
    picture = await loadImage(userId);
  }

  Future<String?> getPictureUrl() async {
    return getImageUrl(userId);
  }

  static UserSumarryData currentUser() {
    final User user = FirebaseAuth.instance.currentUser!;
    return UserSumarryData(
        userId: user.uid,
        firstName: user.displayName!,
        picture: user.photoURL == null ? null : NetworkImage(user.photoURL!));
  }

  static Future<UserSumarryData?> loadFromUserId(String userId) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    Map<String, dynamic>? infos = await users
        .doc(userId)
        .get()
        .then((doc) => doc.data() as Map<String, dynamic>?);
    if (infos == null) {
      return null;
    } else {
      UserSumarryData user =
          UserSumarryData(userId: userId, firstName: infos["firstName"]);
      await user.getPicture();
      return user;
    }
  }
}

class UserData {
  final String userId;
  final String firstName;
  final String lastName;
  final List<String> tags;
  final DateTime birth;
  final String location;
  final String? phone;
  final String description;
  ImageProvider<Object>? picture;

  UserData({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.tags,
    required this.birth,
    required this.location,
    required this.description,
    this.phone,
    this.picture,
  });

  static UserData dummy({
    String userId = "1",
    String firstName = "John",
    String lastName = "Doe",
    List<String> tags = const ["Sport", "Handball"],
    DateTime? birth,
    String location = "Saint Sauveur Lendelin",
    String phone = "0203040506",
    String description =
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
    List<EventData>? events,
  }) {
    return UserData(
        userId: userId,
        firstName: firstName,
        lastName: lastName,
        tags: tags,
        birth: DateTime.parse("19951124"),
        location: "Saint Sauveur Lendelin",
        description: description,
        phone: phone,
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

  @override
  String toString() {
    return toJson().toString();
  }

  Future<String?> getPictureUrl() async {
    return getImageUrl(userId);
  }

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "birth": birth,
      "description": description,
      "tags": tags,
      "location": location,
      "phone": phone,
    };
  }

  static Future<UserData?> loadFromUserId(String userId) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    Map<String, dynamic>? infos = await users
        .doc(userId)
        .get()
        .then((doc) => doc.data() as Map<String, dynamic>?);
    if (infos == null) {
      return null;
    } else {
      return UserData(
          userId: userId,
          firstName: infos["firstName"],
          lastName: infos["lastName"],
          tags: infos["tags"].cast<String>() as List<String>,
          birth: DateTime.fromMillisecondsSinceEpoch(
              infos["birth"].millisecondsSinceEpoch),
          location: infos["location"],
          phone: infos["phone"],
          description: infos["description"]);
    }
  }

  Future<void> save() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    await users.doc(userId).set(toJson(), SetOptions(merge: true));
  }

  Future<List<EventDataSummary>> loadAdminEvents() async {
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');

    return events
        .where("adminId", isEqualTo: userId)
        .get()
        .then((querySnapshot) {
      return Future.wait(querySnapshot.docs
          .map((i) => EventDataSummary.ofJson(i.id, i.data())));
    });
  }

  Future<List<EventDataSummary>> loadAttendesEvents() async {
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');

    return events
        .where("attendesId", arrayContains: userId)
        .get()
        .then((querySnapshot) {
      return Future.wait(querySnapshot.docs
          .map((i) => EventDataSummary.ofJson(i.id, i.data())));
    });
  }
}
