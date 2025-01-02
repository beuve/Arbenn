import 'dart:ui';

import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:arbenn/data/storage.dart';
import 'package:arbenn/pages/forms/event_form/event_form.dart';
import 'package:arbenn/pages/event/future_event_page.dart';
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

  Widget _buildTopRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        StaticGlassTag(data.tags[0].label),
        if (data.maxAttendes != null) ...[
          const SizedBox(width: 10),
          StaticGlassTag(
            " ${data.numAttendes}/${data.maxAttendes}",
            icon: AkarIcons.person,
          )
        ]
      ],
    );
  }

  Widget _location() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          AkarIcons.location,
          color: Colors.white,
          size: 14,
        ),
        const SizedBox(width: 5),
        Text(
          data.address.city,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        )
      ],
    );
  }

  Widget _date() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          AkarIcons.calendar,
          color: Colors.white,
          size: 14,
        ),
        const SizedBox(width: 5),
        Text(
          "${data.date.day} ${monthFromInt(data.date.month)} · ${data.date.hour}:${data.date.minute}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        )
      ],
    );
  }

  Widget _user() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ProfileMiniature(
          pictureUrl: data.admin.pictureUrl,
          size: 12,
        ),
        const SizedBox(width: 5),
        Text(data.admin.firstName,
            style: const TextStyle(color: Colors.white, fontSize: 14))
      ],
    );
  }

  Widget _buildInfosRow() {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: 15,
        direction: Axis.horizontal,
        children: [
          _location(),
          _date(),
          _user(),
        ],
      ),
    );
  }

  Widget _buildBottomInfos() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10.0,
          sigmaY: 10.0,
        ),
        child: Container(
          color: Colors.black.withAlpha(40),
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              _buildInfosRow()
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final creds =
        Provider.of<CredentialsNotifier>(context, listen: false).value!;
    final currentUser =
        context.select((UserDataNotifier currentUser) => currentUser.value);
    return FutureBuilder(
        future: getEventImageUrl(data.eventId, creds: creds),
        builder: (context, snapshot) {
          String? image;
          if (snapshot.hasData && snapshot.data != null) {
            image = snapshot.data!;
          }
          return GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.black12),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: data.colors,
                  tileMode: TileMode.mirror,
                ),
                image: image == null
                    ? null
                    : DecorationImage(
                        colorFilter: const ColorFilter.mode(
                          Color(0x30000000),
                          BlendMode.darken,
                        ),
                        image: NetworkImage(image),
                        fit: BoxFit.cover,
                      ),
              ),
              height: 250,
              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              padding: const EdgeInsets.all(14),
              child: Column(children: [
                _buildTopRow(),
                const Expanded(child: Text("")),
                _buildBottomInfos(),
              ]),
            ),
            onTap: () {
              Navigator.of(context).push(slideIn(FutureEventPage(
                eventSummary: data,
                currentUser: currentUser,
                event: EventData.loadFromEventId(data.eventId, creds: creds),
                onEdit: () => onEditEvent(context),
              )));
            },
          );
        });
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
