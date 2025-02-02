import 'dart:io';

import 'package:arbenn/components/inputs.dart';
import 'package:arbenn/components/snack_bar.dart';
import 'package:arbenn/data/event/event_data.dart';
import 'package:arbenn/data/event/event_search.dart';
import 'package:arbenn/data/tags_data.dart';
import 'package:arbenn/data/user/user_data.dart';
import 'package:arbenn/data/user/authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class EventFormController {
  File? localImage = null;
  String? cloudImageUrl = null;
  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();
  final DatePickingController date = DatePickingController(showTime: true);
  final AddressInputController address = AddressInputController();
  final TagSearch tagSearch = TagSearch();

  initInfos(EventData event, Function() onTap) async {
    title.text = event.title;
    description.text = event.description;
    date.date = event.date;
    address.address = event.address;
    tagSearch.setSelectedTags(event.tags, onTap);
    cloudImageUrl = await event.getImageUrl();
  }

  bool checkEvent(BuildContext context) {
    if (title.text == "") {
      showErrorSnackBar(
        context: context,
        text: "Veillez choisir un titre pour votre événement.",
      );
      return true;
    } else if (tagSearch.tags == []) {
      showErrorSnackBar(
        context: context,
        text: "Veillez sélectionner au moins un tag.",
      );
      return true;
    } else if (date.date == null) {
      showErrorSnackBar(
        context: context,
        text: "Veillez sélectionner une date pour votre événement.",
      );
      return true;
    } else if (address.address == null) {
      showErrorSnackBar(
        context: context,
        text: "Veillez sélectionner une addresse pour votre événement.",
      );
      return true;
    }
    return false;
  }

  Future<bool> updateSearch(EventData? oldEvent, EventData event) async {
    if (oldEvent == null) return false;
    Function eq = const DeepCollectionEquality().equals;
    if (event.title != oldEvent.title ||
        !eq(event.tags, oldEvent.tags) ||
        event.date != oldEvent.date ||
        event.address != oldEvent.address) {
      return Search().update(oldEvent);
    }
    return false;
  }

  Future<EventData?> saveEvent(
      BuildContext context, UserData currentUser, EventData? event) async {
    final creds =
        Provider.of<CredentialsNotifier>(context, listen: false).value!;
    UserSumarryData admin = event != null ? event.admin : currentUser.summary();
    if (checkEvent(context)) return null;
    if (event != null) {
      EventData res = EventData(
        eventId: event.eventId,
        title: title.text,
        tags:
            tagSearch.tags.where((t) => t.isActive).map((t) => t.data).toList(),
        date: date.date!,
        address: address.address!,
        admin: admin,
        description: description.text,
        numAttendes: event.numAttendes,
        attendes: event.attendes,
      );
      bool error = await event
          .save(creds: creds)
          .then((value) async => value || await updateSearch(event, res))
          .then(
        (value) {
          if (value && context.mounted) {
            showErrorSnackBar(
              context: context,
              text: "An error occured 1",
            );
          }
          return value;
        },
      );
      if (error) {
        return null;
      }
      return res;
    } else {
      EventData? event = await EventData.saveNew(
        title: title.text,
        tags:
            tagSearch.tags.where((t) => t.isActive).map((t) => t.data).toList(),
        date: date.date!,
        address: address.address!,
        admin: admin,
        description: description.text,
        creds: creds,
      );
      if (event == null) {
        if (context.mounted) {
          showErrorSnackBar(
            context: context,
            text: "An error occured 2",
          );
        }
        return null;
      } else {
        bool errorIndex = await Search().create(event);
        if (errorIndex) {
          if (context.mounted) {
            showErrorSnackBar(
              context: context,
              text: "An error occured 3",
            );
          }
          return null;
        }
        return event;
      }
    }
  }
}
