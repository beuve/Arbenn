import 'dart:convert';

import 'package:arbenn/data/api.dart';
import 'package:arbenn/data/locations_data.dart';
import 'package:arbenn/data/tags_data.dart';
import 'package:arbenn/data/user/user_data.dart';
import 'package:arbenn/utils/errors/result.dart';
import 'package:flutter/material.dart';
import 'package:arbenn/data/user/authentication.dart';

class EventDataSummary {
  final int eventId;
  final String title;
  final List<TagData> tags;
  final DateTime date;
  final Address address;
  final UserSumarryData admin;
  final int numAttendes;
  final int? maxAttendes;

  const EventDataSummary({
    required this.eventId,
    required this.title,
    required this.tags,
    required this.date,
    required this.address,
    required this.admin,
    required this.numAttendes,
    this.maxAttendes,
  });

  static Future<EventDataSummary> ofJson(Map<String, dynamic> e,
      {required Credentials creds}) async {
    UserSumarryData admin =
        UserSumarryData(userId: e['adminid'], firstName: e['first_name']);
    await admin.getPicture(creds: creds);
    List<TagData> tags = (e['tags'] as List<dynamic>).map((t) {
      return TagData(id: t["id"], label: t["name"]);
    }).toList();
    final event = EventDataSummary(
      eventId: e["eventid"],
      admin: admin,
      title: e['title'],
      tags: tags,
      date: DateTime.parse(e['date']),
      address: Address(
        houseNumber: e['house_number'],
        street: e['street'],
        city: e['city'],
        cityCode: e['city_code'],
        lon: e['lon'],
        lat: e['lat'],
      ),
      maxAttendes: e['max_attendes'],
      numAttendes: e['num_attendes'],
    );
    return event;
  }

  Future<EventDataSummary> updateFromEventData(EventData ev) async {
    return EventDataSummary(
      eventId: eventId,
      title: ev.title,
      tags: ev.tags,
      date: ev.date,
      address: ev.address,
      admin: admin,
      numAttendes: ev.numAttendes,
    );
  }

  static Future<Result<EventDataSummary>> loadFromEventId(int eventId,
      {required Credentials creds}) async {
    return Api.get("/e/getEventSumarryData/$eventId", creds: creds)
        .map((infos) => jsonDecode(infos))
        .futureMap((json) => ofJson(json, creds: creds));
  }

  static Future<Result<List<EventDataSummary>>> loadFromEventIds(
      List<int> eventIds,
      {required Credentials creds}) async {
    final ids = eventIds.join("-");
    return Api.get("/e/getEventsSumarryData/$ids", creds: creds)
        .map((infos) => jsonDecode(infos))
        .futureMap(
            (json) => Future.wait(json.map((e) => ofJson(e, creds: creds))))
        .map((l) => l.toList() as List<EventDataSummary>);
  }

  static Future<Result<List<EventDataSummary>>> loadAttendesEvents(int userId,
      {required Credentials creds}) async {
    return Api.get("/e/getAttendedEventsSumarryData/$userId", creds: creds)
        .map((infos) => jsonDecode(infos))
        .futureMap(
            (json) => Future.wait(json.map((e) => ofJson(e, creds: creds))))
        .map((l) => l.toList() as List<EventDataSummary>);
  }

  static Future<Result<List<EventDataSummary>>> loadFutureAttendesEvents(
      int userId,
      {required Credentials creds}) async {
    return Api.get("/e/getFutureAttendedEventsSumarryData/$userId",
            creds: creds)
        .map((infos) => jsonDecode(infos))
        .futureMap(
            (json) => Future.wait(json.map((e) => ofJson(e, creds: creds))))
        .map((l) => l.toList() as List<EventDataSummary>);
  }
}

class EventData {
  final int eventId;
  String title;
  List<TagData> tags;
  DateTime date;
  Address address;
  UserSumarryData admin;
  String description;
  int numAttendes;
  int? maxAttendes;
  List<UserSumarryData> attendes;

  EventData({
    required this.eventId,
    required this.title,
    required this.tags,
    required this.date,
    required this.address,
    required this.admin,
    required this.description,
    required this.numAttendes,
    this.maxAttendes,
    this.attendes = const [],
  });

  @override
  String toString() {
    return toJson().toString();
  }

  static Future<Result<EventData>> saveNew({
    required String title,
    required List<TagData> tags,
    required DateTime date,
    required Address address,
    required UserSumarryData admin,
    required String description,
    required Credentials creds,
    int? maxAttendes,
  }) async {
    Map<String, dynamic> body = {
      'eventid': -1, //Placeholder
      'street': address.street ?? '',
      'house_number': address.houseNumber ?? '',
      'locality': address.locality ?? '',
      'city': address.city,
      'city_code': address.cityCode,
      'lon': address.lon,
      'lat': address.lat,
      'adminid': admin.userId,
      'first_name': admin.firstName,
      'title': title,
      'date': date.toIso8601String(),
      'max_attendes': maxAttendes,
      'infos': description,
      'tags': tags.map((t) => t.id).toList(),
      'attendes': [],
    };

    return Api.post("/e/createEvent", body: body, creds: creds)
        .map((eventId) => EventData(
              eventId: int.parse(eventId),
              title: title,
              address: address,
              tags: tags,
              date: date,
              admin: admin,
              description: description,
              maxAttendes: maxAttendes,
              attendes: [admin],
              numAttendes: 1,
            ));
  }

  static Future<Result<EventData>> ofJson(Map<String, dynamic> e,
      {required Credentials creds}) async {
    UserSumarryData admin =
        UserSumarryData(userId: e['adminid'], firstName: e['first_name']);
    await admin.getPicture(creds: creds);
    List<UserSumarryData> attendes = e['attendes'] == null
        ? []
        : await Future.wait((e['attendes'] as List<dynamic>).map((u) async {
            UserSumarryData user = UserSumarryData(
                userId: u["userid"], firstName: u["first_name"]);
            await user.getPicture(creds: creds);
            return user;
          }).toList());
    await Future.wait(attendes.map((u) async => u.getPicture(creds: creds)));
    List<TagData> tags = (e['tags'] as List<dynamic>).map((t) {
      return TagData(id: t["id"], label: t["name"]);
    }).toList();
    return Ok(EventData(
      eventId: e['eventid'],
      admin: admin,
      title: e['title'],
      tags: tags,
      date: DateTime.parse(e['date']),
      address: Address(
        houseNumber: e['house_number'] == '' ? null : e['house_number'],
        street: e['street'] == '' ? null : e['street'],
        city: e['city'],
        cityCode: e['city_code'],
        lon: e['lon'],
        lat: e['lat'],
      ),
      maxAttendes: e['max_attendes'],
      numAttendes: attendes.length,
      description: e['infos'],
      attendes: attendes,
    ));
  }

  Map<String, dynamic> toJson() {
    return {
      "eventid": eventId,
      "title": title,
      "date": date.toIso8601String(),
      "infos": description,
      "street": address.street,
      "house_number": address.houseNumber,
      "city": address.city,
      "locality": address.locality,
      "city_code": address.cityCode,
      "lon": address.lon,
      "lat": address.lat,
      "adminid": admin.userId,
      "first_name": admin.firstName,
      "max_attendes": maxAttendes,
      "tags": tags.map((t) => t.id).toList(),
      "attendes": [],
    };
  }

  static Future<Result<EventData>> loadFromEventId(int eventId,
      {required Credentials creds}) async {
    return Api.get("/e/getEventData/$eventId", creds: creds)
        .map((infos) => jsonDecode(infos))
        .futureBind((json) => ofJson(json, creds: creds));
  }

  Future<Result<()>> save({required Credentials creds}) async {
    return Api.post("/e/setEventData/$eventId", body: toJson(), creds: creds)
        .map((infos) => ()); // Discard the result
  }

  Future<String?> getImageUrl() async {
    // TODO
    return null;
  }

  Future<void> addAttende(UserSumarryData user,
      {required Credentials creds}) async {
    if (!attendes.any(
      (u) => u.userId == user.userId,
    )) {
      await Api.post("/e/addAttende/$eventId", body: user.userId, creds: creds);
      attendes.add(user);
    }
  }

  Future<void> removeAttende(int userId, {required Credentials creds}) async {
    await Api.post("/e/removeAttende/$eventId", body: userId, creds: creds);
    attendes.removeWhere(
      (u) => u.userId == creds.userId,
    );
  }
}

class AttendeEventsNotifier extends ChangeNotifier {
  late Future<Result<List<EventDataSummary>>> _evs;

  AttendeEventsNotifier(int userId, {required Credentials creds}) {
    // Is it the good thing to do?
    _evs = EventDataSummary.loadAttendesEvents(userId, creds: creds);
  }

  Future<Result<List<EventDataSummary>>> get events => _evs;

  set value(Future<Result<List<EventDataSummary>>> newEvents) {
    _evs = newEvents;
    notifyListeners();
  }

  Future<Result<List<EventDataSummary>>> get value => _evs;

  void add(EventDataSummary newEvent) {
    _evs = _evs.map((evs) => [newEvent, ...evs]);
  }

  void reload(int userId, {required Credentials creds}) {
    _evs = EventDataSummary.loadAttendesEvents(userId, creds: creds);
  }

  void setEvent(EventData eventData) {
    _evs = _evs.then((evs) async {
      if (evs.isOk()) {
        Future.wait(evs.unwrap().map((ev) async {
          if (ev.eventId == eventData.eventId) {
            return ev.updateFromEventData(eventData);
          } else {
            return ev;
          }
        }).toList());
      }
      return Err((evs as Err).error);
    });
    notifyListeners();
  }
}

class HomeEventsNotifier extends ChangeNotifier {
  Future<List<EventDataSummary>?> _evs;

  HomeEventsNotifier(Future<List<EventDataSummary>?> events) : _evs = events;

  Future<List<EventDataSummary>?> get events => _evs;

  set value(Future<List<EventDataSummary>?> newEvents) {
    _evs = newEvents;
    notifyListeners();
  }

  Future<List<EventDataSummary>?> get value => _evs;

  void add(EventDataSummary newEvent) {
    _evs = _evs.then((evs) => [newEvent, ...?evs]);
  }

  void setEvent(EventDataSummary eventDataSummary) {
    _evs = _evs.then((evs) {
      if (evs != null) {
        evs.map((ev) {
          if (ev.eventId == eventDataSummary.eventId) {
            return eventDataSummary;
          } else {
            return ev;
          }
        }).toList();
      }
      return null;
    });
    notifyListeners();
  }
}
