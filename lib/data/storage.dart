import 'dart:typed_data';

import 'package:arbenn/data/api.dart';
import 'package:arbenn/data/user/authentication.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'dart:io';

Future<void> saveProfileImage(
  String path, {
  required Credentials creds,
}) async {
  saveImage('/s/setUserProfile', path,
      sizes: {"/regular": 1000, "/tiny": 50}, quality: 50, creds: creds);
}

Future<void> saveEventImage(
  int eventid,
  String path, {
  required Credentials creds,
}) async {
  saveImage('/s/setEventImage/$eventid', path, creds: creds);
}

Future<bool> deleteImage({
  required Credentials creds,
}) async {
  await Api.get(
    '/s/deleteUserProfile',
    creds: creds,
  );
  return false;
}

Future<bool> saveImage(
  String path,
  String localPath, {
  required Credentials creds,
  Map<String, int>? sizes,
  int quality = 60,
}) async {
  img.Image? image = img.decodeImage(File(localPath).readAsBytesSync());
  if (image == null) return true;
  if (sizes == null) {
    await Api.postImage(
      path,
      creds: creds,
      image: Uint8List.fromList(img.encodeJpg(image, quality: quality)),
    );
    return false;
  } else {
    await Future.forEach<MapEntry<String, int>>(sizes.entries, (e) async {
      bool isWidthMax = image.height < image.width;
      img.Image resizedImage = img.copyResize(
        image,
        width: isWidthMax ? e.value : null,
        height: isWidthMax ? null : e.value,
      );
      final _ = await Api.postImage(
        "$path${e.key}",
        creds: creds,
        image:
            Uint8List.fromList(img.encodeJpg(resizedImage, quality: quality)),
      );
    });
    return false;
  }
}

Future<ImageProvider?> loadImage(String bucket, String id) async {
  return null;
}

Future<String?> getEventImageUrl(int eventid,
    {required Credentials creds}) async {
  final res = await Api.get("/s/getEventImageUrl/$eventid", creds: creds);
  return res;
}

Future<String?> getProfileUrl(String userid, String size,
    {required Credentials creds}) async {
  final res = await Api.get("/s/getProfileUrl/$userid/$size", creds: creds);
  return res;
}
