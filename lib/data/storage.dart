import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'dart:developer' as developer;

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
  saveImage('userProfiles/$id', path,
      sizes: {"": 500, "_tiny": 50}, quality: 50);
}

Future<bool> saveImage(String cloudPath, String localPath,
    {Map<String, int>? sizes, int quality = 60}) async {
  if (sizes == null) {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images')
        .child(cloudPath);
    try {
      img.Image? image = img.decodeImage(File(localPath).readAsBytesSync());
      if (image == null) return true;
      ref.putData(Uint8List.fromList(img.encodeJpg(image, quality: quality)),
          firebase_storage.SettableMetadata(contentType: "image/jpeg"));
      return false;
    } on FirebaseException catch (e) {
      developer.log("Error when saving on firebase (no size)",
          name: "data/storage saveImage", error: e);
      return true;
    }
  } else {
    img.Image? image = img.decodeImage(File(localPath).readAsBytesSync());
    if (image == null) return true;
    try {
      await Future.forEach<MapEntry<String, int>>(sizes.entries, (e) async {
        bool isWidthMax = image.height < image.width;
        img.Image resizedImage = img.copyResize(
          image,
          width: isWidthMax ? e.value : null,
          height: isWidthMax ? null : e.value,
        );
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('images')
            .child(cloudPath + e.key);
        ref.putData(
            Uint8List.fromList(img.encodeJpg(resizedImage, quality: quality)),
            firebase_storage.SettableMetadata(contentType: "image/jpeg"));
      });
      return false;
    } on FirebaseException catch (e) {
      developer.log("Error when saving on firebase (with size)",
          name: "data/storage saveImage", error: e);

      return true;
    }
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
    developer.log("Error when loading image from firebase",
        name: "data/storage loadImage", error: e);
    return null;
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
    developer.log("Error when querying url from firebase",
        name: "data/storage getIconUrl", error: e);
    return null;
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
    developer.log("Error when querying url from firebase",
        name: "data/storage getImageUrl", error: e);
    return null;
  }
}
