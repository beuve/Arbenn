import 'dart:io';

import 'package:arbenn/components/inputs.dart';
import 'package:arbenn/data/event/event_data.dart';
import 'package:arbenn/data/event/event_search.dart';
import 'package:arbenn/data/tags_data.dart';
import 'package:arbenn/data/user/user_data.dart';
import 'package:arbenn/data/user/authentication.dart';
import 'package:arbenn/utils/errors/exceptions.dart';
import 'package:arbenn/utils/errors/result.dart';
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

  Result<()> checkEvent(BuildContext context) {
    if (title.text == "") {
      return const Err(ArbennException("[EventForm] Missing title",
          userMessage: "Veillez choisir un titre pour votre événement.",
          kind: ErrorKind.userInput));
    } else if (tagSearch.tags == []) {
      return const Err(ArbennException("[EventForm] Missing tags",
          userMessage: "Veillez sélectionner au moins un tag.",
          kind: ErrorKind.userInput));
    } else if (date.date == null) {
      return const Err(ArbennException("[EventForm] Missing date",
          userMessage: "Veillez sélectionner une date pour votre événement.",
          kind: ErrorKind.userInput));
    } else if (address.address == null) {
      return const Err(ArbennException("[EventForm] Missing address",
          userMessage:
              "Veillez sélectionner une addresse pour votre événement.",
          kind: ErrorKind.userInput));
    }
    return const Ok(());
  }

  Future<Result<()>> updateSearch(EventData? oldEvent, EventData event) async {
    if (oldEvent == null) {
      return const Err(ArbennException(
          "[EventForm] Can't update search without previous event"));
    }
    Function eq = const DeepCollectionEquality().equals;
    if (event.title != oldEvent.title ||
        !eq(event.tags, oldEvent.tags) ||
        event.date != oldEvent.date ||
        event.address != oldEvent.address) {
      return Search().update(oldEvent);
    }
    return const Ok(());
  }

  Future<Result<EventData>> saveEvent(
      BuildContext context, UserData currentUser, EventData? event) async {
    final creds =
        Provider.of<CredentialsNotifier>(context, listen: false).value!;
    UserSumarryData admin = event != null ? event.admin : currentUser.summary();
    Result<()> check = checkEvent(context);
    if (check.isErr()) return Err((check as Err).error);
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
      return event
          .save(creds: creds)
          .futureBind((_) => updateSearch(event, res))
          .map((_) => res);
    } else {
      return EventData.saveNew(
        title: title.text,
        tags:
            tagSearch.tags.where((t) => t.isActive).map((t) => t.data).toList(),
        date: date.date!,
        address: address.address!,
        admin: admin,
        description: description.text,
        creds: creds,
      ).futureMap((event) async {
        await Search().create(event);
        return event;
      });
    }
  }
}
