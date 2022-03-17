import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

class CloudImage {
  final firebase_storage.Reference ref;
  final ImageProvider image;

  CloudImage({required this.ref, required this.image});

  static Future<CloudImage> loadImage(firebase_storage.Reference ref) async {
    final String url = await ref.getDownloadURL();
    final NetworkImage image = NetworkImage(url);
    return CloudImage(ref: ref, image: image);
  }
}

Future<void> saveProfileImage(String id, String path) async {
  saveImage('userProfiles/$id', path);
}

Future<void> saveImage(String cloudPath, String localPath) async {
  firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
      .ref()
      .child('images')
      .child(cloudPath);
  try {
    ref.putFile(File(localPath));
  } on FirebaseException catch (e) {
    // e.g, e.code == 'canceled'
  }
}

Future<ImageProvider?> loadImage(String id) async {
  firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
      .ref()
      .child('images')
      .child('userProfiles')
      .child(id);
  try {
    ImageProvider image =
        await ref.getDownloadURL().then((url) => NetworkImage(url));
    return image;
  } on FirebaseException catch (e) {
    return null;
    // e.g, e.code == 'canceled'
  }
}

Future<String?> getIconUrl(String id) async {
  firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
      .ref()
      .child('icons')
      .child("$id.svg");
  try {
    return ref.getDownloadURL();
  } on FirebaseException catch (e) {
    return null;
    // e.g, e.code == 'canceled'
  }
}

Future<String?> getImageUrl(String id) async {
  firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
      .ref()
      .child('images')
      .child('userProfiles')
      .child(id);
  try {
    String? url = await ref.getDownloadURL();
    return url;
  } on FirebaseException catch (e) {
    return null;
    // e.g, e.code == 'canceled'
  }
}
