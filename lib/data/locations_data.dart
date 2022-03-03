import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String host = "api-adresse.data.gouv.fr";
const String path = "search";

class Address {
  final double lon, lat;
  final String houseNumber, street, city, cityCode;

  const Address({
    required this.lon,
    required this.lat,
    required this.houseNumber,
    required this.street,
    required this.city,
    required this.cityCode,
  });

  static Future<List<Address>> fromQuery(String query, [limit = 15]) async {
    Uri uri = Uri(
      scheme: "https",
      host: host,
      path: path,
      query: query,
      queryParameters: {"limit": limit, "type": "housenumber"},
    );
    http.Response response = await http.get(uri);
    print(response.body);
    return [];
  }

  Autocomplete<Address> get autocomplete {
    return Autocomplete(search: fromQuery);
  }
}

class City {
  final GeoPoint coord;
  final String city, cityCode;

  const City({
    required this.coord,
    required this.city,
    required this.cityCode,
  });

  static Future<List<City>> fromQuery(String query, [int limit = 15]) async {
    Uri uri = Uri(
      scheme: "https",
      host: host,
      path: path,
      queryParameters: {
        "limit": [limit.toString()],
        "type": ["municipality"],
        "q": [query]
      },
    );
    http.Response response = await http.get(uri);
    List<City> result = [];
    try {
      Map<String, dynamic> json = jsonDecode(response.body);
      result = (json["features"] as List<dynamic>)
          .map((e) => City(
                city: e["properties"]["label"],
                cityCode: e["properties"]["postcode"],
                coord: GeoPoint(
                    (e["geometry"]["coordinates"] as List<dynamic>)[1],
                    (e["geometry"]["coordinates"] as List<dynamic>)[0]),
              ))
          .toList();
    } catch (e) {
      print("error: $e");
    }

    return result;
  }

  static Autocomplete<City> get autocomplete {
    return Autocomplete(search: fromQuery);
  }

  @override
  String toString() {
    return "$city ($cityCode)";
  }

  Map<String, dynamic> toJson() {
    return {
      "city": city,
      "cityCode": cityCode,
      "coord": coord,
    };
  }

  static City ofJson(Map<String, dynamic> infos) {
    return City(
      city: infos["city"],
      cityCode: infos["cityCode"],
      coord: infos["coord"],
    );
  }
}

class Autocomplete<T> extends ValueNotifier<bool> {
  final Future<List<T>> Function(String) search;
  final Duration delay;
  late StreamController<List<T>> _streamController;
  late TextEditingController _textController;

  void tick(_) async {
    if (_textController.text.length > 1 && !value) {
      value = true;
      await Future.delayed(delay);
      List<T> addresses = await search(_textController.text);
      _streamController.add(addresses);
      value = false;
    } else if (!value) {
      _streamController.add([]);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
    _textController.dispose();
  }

  Autocomplete({
    required this.search,
    this.delay = Duration.zero,
    TextEditingController? controller,
  }) : super(false) {
    _streamController = StreamController<List<T>>();
    _textController = controller ?? TextEditingController();
    _textController.addListener(() => tick(0));
  }

  Stream<List<T>> get stream => _streamController.stream;
  TextEditingController get controller => _textController;
  bool get isSearching => value;

  set setSearchState(bool newValue) {
    value = newValue;
  }
}
