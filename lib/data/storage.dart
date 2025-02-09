import 'dart:typed_data';

import 'package:arbenn/data/api.dart';
import 'package:arbenn/data/user/authentication.dart';
import 'package:arbenn/utils/errors/exceptions.dart';
import 'package:arbenn/utils/errors/result.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'dart:io';

Future<Result<()>> saveProfileImage(
  String path, {
  required Credentials creds,
}) async {
  return saveImage('/s/setUserProfile', path,
      sizes: {"/regular": 1000, "/tiny": 50}, quality: 50, creds: creds);
}

Future<Result<()>> saveEventImage(
  int eventid,
  String path, {
  required Credentials creds,
}) async {
  return saveImage('/s/setEventImage/$eventid', path, creds: creds);
}

Future<Result<()>> deleteImage({
  required Credentials creds,
}) async {
  await Api.get(
    '/s/deleteUserProfile',
    creds: creds,
  );
  return const Ok(());
}

Future<Result<()>> saveImage(
  String path,
  String localPath, {
  required Credentials creds,
  Map<String, int>? sizes,
  int quality = 60,
}) async {
  img.Image? image = img.decodeImage(File(localPath).readAsBytesSync());
  if (image == null) {
    return const Err(ArbennException("[Storage] Couldn't save image"));
  }
  if (sizes == null) {
    await Api.postImage(
      path,
      creds: creds,
      image: Uint8List.fromList(img.encodeJpg(image, quality: quality)),
    );
    return const Ok(());
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
    return const Ok(());
  }
}

Future<ImageProvider?> loadImage(String bucket, String id) async {
  return null;
}

Future<Result<String>> getEventImageUrl(int eventid,
    {required Credentials creds}) async {
  return Api.get("/s/getEventImageUrl/$eventid", creds: creds);
}

Future<Result<String>> getProfileUrl(String userid, String size,
    {required Credentials creds}) async {
  return Api.get("/s/getProfileUrl/$userid/$size", creds: creds);
}
