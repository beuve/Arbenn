import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:arbenn/utils/constants.dart';
import 'package:arbenn/utils/errors/exceptions.dart';
import 'package:arbenn/utils/errors/result.dart';
import 'package:http/http.dart' as http;
import 'package:arbenn/data/user/authentication.dart';

class Api {
  static const root = "${Constants.serverHost}:${Constants.serverPort}";

  static Result<String> handleResponse(http.Response response) {
    if (response.statusCode != 200) {
      return Err(ArbennException(
          "${response.statusCode}: ${response.reasonPhrase}",
          userMessage: "An error occured, verify your internet connection!"));
    }
    return Ok(response.body);
  }

  static Future<Result<String>> unsafeGet(String path) async {
    var url = Uri.http(root, path);
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    return http
        .get(url, headers: headers)
        .then((response) => Ok(response) as Result<http.Response>)
        .onError((error, stack) => Err(ArbennException(
            "[Api::unsafeGet] $error",
            userMessage: "An error occured, verify your internet connection!")))
        .bind(handleResponse);
  }

  static Future<Result<String>> unsafePost(String path,
      {required dynamic body}) async {
    var url = Uri.http(root, path);
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    return http
        .post(url, headers: headers, body: json.encode(body))
        .then((response) => Ok(response) as Result<http.Response>)
        .onError((error, stack) => Err(ArbennException(
            "[Api::unsafeGet] $error",
            userMessage: "An error occured, verify your internet connection!")))
        .bind(handleResponse);
  }

  static Future<Result<String>> get(String path,
      {required Credentials creds}) async {
    var url = Uri.http(root, path);
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization':
          'Bearer {"userid": ${creds.userId}, "token": "${creds.token}"}'
    };
    return http
        .get(url, headers: headers)
        .then((response) => Ok(response) as Result<http.Response>)
        .onError((error, stack) => Err(ArbennException(
            "[Api::unsafeGet] $error",
            userMessage: "An error occured, verify your internet connection!")))
        .bind(handleResponse);
  }

  static Future<Result<String>> post(String path,
      {required Credentials creds, required dynamic body}) async {
    var url = Uri.http(root, path);
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization':
          'Bearer {"userid": ${creds.userId}, "token": "${creds.token}"}'
    };
    return http
        .post(url, headers: headers, body: json.encode(body))
        .then((response) => Ok(response) as Result<http.Response>)
        .onError((error, stack) => Err(ArbennException(
            "[Api::unsafeGet] $error",
            userMessage: "An error occured, verify your internet connection!")))
        .bind(handleResponse);
  }

  static Future<Result<String>> postImage(String path,
      {required Credentials creds, required Uint8List image}) async {
    var url = Uri.http(root, path);
    var request = http.MultipartRequest(
      'POST',
      url,
    );
    Map<String, String> headers = {
      "Content-type": "multipart/form-data",
      'Authorization':
          'Bearer {"userid": ${creds.userId}, "token": "${creds.token}"}'
    };
    request.files.add(
      http.MultipartFile(
        'image',
        Stream.value(
          List<int>.from(image),
        ),
        image.length,
        filename: "${creds.userId}.jpeg",
      ),
    );
    request.headers.addAll(headers);
    var res = await request.send();
    http.Response response = await http.Response.fromStream(res);
    return Ok(response.body);
  }

  static Future<String?> getImage(String path,
      {required Credentials creds}) async {
    var url = Uri.http(root, path);
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'image/jpeg',
      'Authorization':
          'Bearer {"userid": ${creds.userId}, "token": "${creds.token}"}'
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode != 200) {
      return null;
    }
    return response.body;
  }

  static Future<WebSocket> socket(String path,
      {required Credentials creds}) async {
    var url = Uri(
      scheme: "ws",
      host: Constants.serverHost,
      port: int.parse(Constants.serverPort),
      path: path,
    );
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization':
          'Bearer {"userid": ${creds.userId}, "token": "${creds.token}"}'
    };
    var response = await WebSocket.connect(url.toString(), headers: headers);
    return response;
  }
}
