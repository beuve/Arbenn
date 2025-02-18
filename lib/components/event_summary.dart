import 'dart:ui';

import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:arbenn/data/storage.dart';
import 'package:arbenn/pages/forms/event_form/event_form.dart';
import 'package:arbenn/pages/event/future_event_page.dart';
import 'package:arbenn/themes/arbenn_colors.dart';
import 'package:arbenn/utils/page_transitions.dart';
import 'package:arbenn/components/placeholders.dart';
import 'package:arbenn/components/scroller.dart';
import 'package:arbenn/components/tags.dart';
import 'package:arbenn/components/profile_miniature.dart';
import 'package:arbenn/data/user/user_data.dart';
import 'package:arbenn/utils/date.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:arbenn/data/event/event_data.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:arbenn/data/user/authentication.dart';

class _EventSummaryError extends StatelessWidget {
  const _EventSummaryError();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 250,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.grey),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Oups, something wrong happened. Verify your internet connection and retry.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ],
      ),
    );
  }
}

class _EventSummaryErrorView extends StatelessWidget {
  final Future<void> Function()? onRefresh;

  const _EventSummaryErrorView({
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollList(
      onRefresh: onRefresh,
      children: const [_EventSummaryError()],
    );
  }
}

class _EventSummaryNoData extends StatelessWidget {
  final String text;
  const _EventSummaryNoData({required this.text});

  void openEventForm(BuildContext context) async {
    final UserData currentUser =
        Provider.of<UserDataNotifier>(context, listen: false).value;
    Navigator.of(context).push(slideIn(EventFormPage(admin: currentUser)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 250,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.grey),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black, fontSize: 20),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: 250,
            child: ElevatedButton(
              child: const Text("Crées ton événement !"),
              onPressed: () => openEventForm(context),
            ),
          )
        ],
      ),
    );
  }
}

class _EventSummaryNoDataView extends StatelessWidget {
  final Future<void> Function()? onRefresh;
  final String text;

  const _EventSummaryNoDataView({
    required this.onRefresh,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollList(
      onRefresh: onRefresh,
      children: [_EventSummaryNoData(text: text)],
    );
  }
}

class _EventSummaryPlaceholder extends StatelessWidget {
  final double tick;

  const _EventSummaryPlaceholder({
    this.tick = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Color.lerp(Colors.grey[50], Colors.grey[200], tick)),
    );
  }
}

class _EventSummariesPlaceHolders extends StatelessWidget {
  final int num;

  const _EventSummariesPlaceHolders({
    this.num = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TickingBuilder(
              builder: (context, tick) => ScrollList(
                  children:
                      List.filled(num, _EventSummaryPlaceholder(tick: tick))),
            ),
          )
        ],
      ),
    );
  }
}

class EventSummary extends StatelessWidget {
  final EventDataSummary data;

  const EventSummary({
    super.key,
    required this.data,
  });

  void onEditEvent(BuildContext context) {
    final creds =
        Provider.of<CredentialsNotifier>(context, listen: false).value!;
    final currentUser =
        Provider.of<UserDataNotifier>(context, listen: false).value;
    Provider.of<AttendeEventsNotifier>(context, listen: false)
        .reload(currentUser.userId, creds: creds);
  }

  Widget ownerEvent(Nuances nuances) {
    return Text.rich(
      TextSpan(
        style: TextStyle(color: nuances.darker),
        children: [
          WidgetSpan(
            child: ProfileMiniature(
              pictureUrl: data.admin.pictureUrl,
              size: 15,
            ),
          ),
          TextSpan(text: " ${data.admin.firstName}")
        ],
      ),
    );
  }

  Widget attendes(Nuances nuances) {
    final String maxAttendes =
        (data.maxAttendes == null) ? "" : " / ${data.maxAttendes}";
    return Container(
        padding: const EdgeInsets.only(top: 5, right: 5),
        width: 50,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 15,
              alignment: Alignment.center,
              child: Icon(
                AkarIcons.person,
                size: 10,
                color: nuances.darker,
              ),
            ),
            Text(" ${data.numAttendes}$maxAttendes",
                style: TextStyle(
                  color: nuances.darker,
                  fontSize: 10,
                ))
          ],
        ));
  }

  Widget title(Nuances nuances) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: RichText(
        maxLines: 2,
        text: TextSpan(
            style: TextStyle(
                color: nuances.darker,
                fontSize: 20,
                height: 1.3,
                fontWeight: FontWeight.bold),
            children: [
              TextSpan(text: "${data.title.trim()} "),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: FittedBox(child: StaticTag.outlined(data.tags.first)),
              )
            ]),
      ),
    );
  }

  Widget dateEvent(Nuances nuances) {
    return Text.rich(
      TextSpan(
        style: TextStyle(color: nuances.darker),
        children: [
          WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Icon(
                AkarIcons.calendar,
                color: nuances.darker,
                size: 15,
              )),
          dateToString(data.date)
        ],
      ),
    );
  }

  Widget locationEvent(Nuances nuances) {
    return Text.rich(
      TextSpan(
        style: TextStyle(color: nuances.darker),
        children: [
          WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Icon(
                AkarIcons.location,
                color: nuances.darker,
                size: 15,
              )),
          TextSpan(
              text: " ${data.address.city}",
              style: const TextStyle(fontWeight: FontWeight.w500))
        ],
      ),
    );
  }

  Widget top(Nuances nuances) {
    return SizedBox(
        height: 60,
        child: Row(
            children: [Expanded(child: title(nuances)), attendes(nuances)]));
  }

  Widget bottom(Nuances nuances) {
    return Container(
        height: 50,
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
        child: Row(children: [
          locationEvent(nuances),
          Expanded(child: Container()),
          dateEvent(nuances),
          Expanded(child: Container()),
          ownerEvent(nuances)
        ]));
  }

  @override
  Widget build(BuildContext context) {
    final nuances = data.tags.first.nuances;
    final currentUser =
        Provider.of<UserDataNotifier>(context, listen: false).value;
    final creds =
        Provider.of<CredentialsNotifier>(context, listen: false).value!;
    return GestureDetector(
      child: Container(
          height: 115,
          margin: const EdgeInsets.only(bottom: 30),
          padding: const EdgeInsets.only(bottom: 5, right: 5, left: 5),
          decoration: BoxDecoration(
            color: nuances.main,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            children: [top(nuances), bottom(nuances)],
          )),
      onTap: () {
        Navigator.of(context).push(slideIn(FutureEventPage(
          eventSummary: data,
          currentUser: currentUser,
          event: EventData.loadFromEventId(data.eventId, creds: creds),
          onEdit: () => onEditEvent(context),
        )));
      },
    );
  }
}

class FutureOptionEventSummaryView extends StatelessWidget {
  final Future<List<EventDataSummary>?> events;
  final int numPlaceholders;
  final Future<void> Function()? onRefresh;
  final Widget? header;
  final String? emptyText;

  const FutureOptionEventSummaryView({
    super.key,
    required this.events,
    required this.emptyText,
    this.header,
    this.onRefresh,
    this.numPlaceholders = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null)
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: header!),
          Expanded(
            child: FutureBuilder<List<EventDataSummary>?>(
              future: events,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == null) {
                    return _EventSummaryErrorView(
                      onRefresh: onRefresh,
                    );
                  } else if (emptyText != null && snapshot.data!.isEmpty) {
                    return _EventSummaryNoDataView(
                      text: emptyText!,
                      onRefresh: onRefresh,
                    );
                  }
                  return ScrollList(
                    onRefresh: onRefresh,
                    children: [
                      ...snapshot.data!.map((e) => EventSummary(data: e))
                    ],
                  );
                }
                return _EventSummariesPlaceHolders(
                  num: numPlaceholders,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FutureOptionEventSummary extends StatelessWidget {
  final Future<List<EventDataSummary>?> events;
  final int numPlaceholders;

  const FutureOptionEventSummary({
    super.key,
    required this.events,
    this.numPlaceholders = 1,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EventDataSummary>?>(
      future: events,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null) {
            return const Column(children: []);
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [...snapshot.data!.map((e) => EventSummary(data: e))],
          );
        }
        return TickingBuilder(
          builder: (context, tick) => Column(
              children: List.filled(
                  numPlaceholders, _EventSummaryPlaceholder(tick: tick))),
        );
      },
    );
  }
}
