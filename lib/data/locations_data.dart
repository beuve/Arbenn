import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String host = "api-adresse.data.gouv.fr";
const String path = "search";

class Address {
  final GeoPoint coord;
  final String? street, houseNumber, locality;
  final String city, cityCode;

  const Address({
    required this.coord,
    this.street,
    this.houseNumber,
    this.locality,
    required this.city,
    required this.cityCode,
  });

  static Future<List<Address>> fromQuery(String query, [limit = 15]) async {
    Uri uri = Uri(
      scheme: "https",
      host: host,
      path: path,
      queryParameters: {
        "limit": [limit.toString()],
        //"type": ["housenumber"],
        "q": [query]
      },
    );

    Address readHouseNumber(Map<String, dynamic> infos) {
      return Address(
        houseNumber: infos["properties"]["housenumber"],
        street: infos["properties"]["street"],
        city: infos["properties"]["city"],
        cityCode: infos["properties"]["postcode"],
        coord: GeoPoint((infos["geometry"]["coordinates"] as List<dynamic>)[1],
            (infos["geometry"]["coordinates"] as List<dynamic>)[0]),
      );
    }

    Address readStreet(Map<String, dynamic> infos) {
      return Address(
        street: infos["properties"]["name"],
        city: infos["properties"]["city"],
        cityCode: infos["properties"]["postcode"],
        coord: GeoPoint((infos["geometry"]["coordinates"] as List<dynamic>)[1],
            (infos["geometry"]["coordinates"] as List<dynamic>)[0]),
      );
    }

    Address readLocality(Map<String, dynamic> infos) {
      return Address(
        locality: infos["properties"]["name"],
        city: infos["properties"]["city"],
        cityCode: infos["properties"]["postcode"],
        coord: GeoPoint((infos["geometry"]["coordinates"] as List<dynamic>)[1],
            (infos["geometry"]["coordinates"] as List<dynamic>)[0]),
      );
    }

    Address readMunicipality(Map<String, dynamic> infos) {
      return Address(
        city: infos["properties"]["city"],
        cityCode: infos["properties"]["postcode"],
        coord: GeoPoint((infos["geometry"]["coordinates"] as List<dynamic>)[1],
            (infos["geometry"]["coordinates"] as List<dynamic>)[0]),
      );
    }

    http.Response response = await http.get(uri);
    List<Address> result = [];
    try {
      Map<String, dynamic> json = jsonDecode(response.body);
      result = (json["features"] as List<dynamic>).map((e) {
        switch (e["properties"]["type"]) {
          case "municipality":
            return readMunicipality(e);
          case "street":
            return readStreet(e);
          case "housenumber":
            return readHouseNumber(e);
          case "locality":
            return readLocality(e);
          default:
            throw Exception("Wring type: ${e["properties"]["type"]} $e");
        }
      }).toList();
    } catch (e) {
      print("error: $e");
    }

    return result;
  }

  static Autocomplete<Address> get autocomplete {
    return Autocomplete(search: fromQuery);
  }

  @override
  String toString() {
    assert((locality == null && street == null && houseNumber == null) ||
        (locality != null && street == null && houseNumber == null) ||
        (locality == null && street != null));

    assert(!(houseNumber != null && street == null));

    String number = houseNumber == null ? "" : "$houseNumber ";
    String streetName = street == null ? "" : "$street, ";
    String localityName = locality == null ? "" : "$locality, ";
    return "$number$streetName$localityName$city ($cityCode)";
  }

  Map<String, dynamic> toJson() {
    return {
      "houseNumber": houseNumber,
      "street": street,
      "city": city,
      "cityCode": cityCode,
      "coord": coord,
    };
  }

  static Address ofJson(Map<String, dynamic> infos) {
    return Address(
      street: infos["street"],
      houseNumber: infos["houseNumber"],
      city: infos["city"],
      cityCode: infos["cityCode"],
      coord: infos["coord"],
    );
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
      if (!_streamController.isClosed) {
        _streamController.add(addresses);
        value = false;
      }
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
