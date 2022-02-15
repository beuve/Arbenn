import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

Future<Image?> saveImage(String id, String path) async {
  firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
      .ref()
      .child('images')
      .child('userProfiles')
      .child(id);
  try {
    ref.putFile(File(path));
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
