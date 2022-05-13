import 'package:arbenn/data/locations_data.dart';
import 'package:arbenn/data/storage.dart';
import 'package:arbenn/data/tags_data.dart';
import 'package:flutter/material.dart';
import 'package:arbenn/data/event_data.dart';

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
    picture = await loadImage("${userId}_tiny");
  }

  Future<String?> getPictureUrl() async {
    return getImageUrl("${userId}_tiny");
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
  final List<TagData> tags;
  final DateTime birth;
  final City location;
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

  Future<void> loadPicture() async {
    picture = await loadImage(userId);
  }

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "birth": birth,
      "description": description,
      "tags": tags.map((e) => e.id).toList(),
      "city": location.toJson(),
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
      List<TagData>? tags = await TagData.loadFromIds(
          infos["tags"].cast<String>() as List<String>);
      if (tags == null) {
        return null;
      }
      UserData res = UserData(
          userId: userId,
          firstName: infos["firstName"],
          lastName: infos["lastName"],
          tags: tags,
          birth: DateTime.fromMillisecondsSinceEpoch(
              infos["birth"].millisecondsSinceEpoch),
          location: City.ofJson(infos["city"]),
          phone: infos["phone"],
          description: infos["description"]);
      await res.loadPicture();
      return res;
    }
  }

  Future<bool> save() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    bool res = await users
        .doc(userId)
        .set(toJson(), SetOptions(merge: true))
        .then((_) => false)
        .onError((error, stackTrace) => true);
    return res;
  }

  Future<List<EventDataSummary>?> loadAdminEvents() async {
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');

    return events
        .where("adminId", isEqualTo: userId)
        .get()
        .then((querySnapshot) async {
      List<Map<String, dynamic>> infos = querySnapshot.docs.map((i) {
        Map<String, dynamic> data = i.data() as Map<String, dynamic>;
        data["eventId"] = i.id;
        return data;
      }).toList();
      return EventDataSummary.ofJsons(infos);
    });
  }

  Stream<List<EventDataSummary>?> loadAttendesEvents() {
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');

    return events
        .where("attendesId", arrayContains: userId)
        .snapshots()
        .asyncMap((querySnapshot) async {
      List<Map<String, dynamic>> infos = querySnapshot.docs.map((i) {
        Map<String, dynamic> data = i.data() as Map<String, dynamic>;
        data["eventId"] = i.id;
        return data;
      }).toList();
      return EventDataSummary.ofJsons(infos);
    });
  }
}
