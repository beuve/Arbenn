import 'package:arbenn/components/page_transitions.dart';
import 'package:arbenn/components/placeholders.dart';
import 'package:arbenn/components/scroller.dart';
import 'package:arbenn/utils/icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart' hide BackButton;
import '../utils/colors.dart';
import '../data/event_data.dart';
import 'tags.dart';
import '../pages/event_page.dart';
import 'user_elements.dart';
import 'dart:async';

class EventSummaryNoData extends StatelessWidget {
  final Nuance color;

  const EventSummaryNoData({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollList(
      children: [
        Container(
          alignment: Alignment.center,
          height: 150,
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: color.dark),
          child: Column(
            children: [
              Icon(
                ArbennIcons.info,
                color: color.lighter,
                size: 20,
              ),
              const SizedBox(height: 10),
              Text(
                "Une erreur de chargement s'est produite. Verifiez votre connexion internet.",
                textAlign: TextAlign.center,
                style: TextStyle(color: color.lighter, fontSize: 20),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ],
      color: color,
    );
  }
}

class EventSummaryPlaceholder extends StatelessWidget {
  final Nuance color;
  final double tick;

  const EventSummaryPlaceholder({
    Key? key,
    required this.color,
    this.tick = 0,
  }) : super(key: key);

  Widget _buildDivider() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      margin: const EdgeInsets.only(right: 10),
      alignment: Alignment.center,
      child: VerticalDivider(
        width: 3,
        thickness: 1,
        color: color.lighter,
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 130,
      alignment: Alignment.center,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: color.lighter,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }

  Widget _buildDataSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        TextPlaceholder(color: color.lighter, width: 150),
        const SizedBox(height: 42),
        TextPlaceholder(color: color.lighter, width: 110),
        const SizedBox(height: 7),
        TextPlaceholder(color: color.lighter, width: 70),
        const SizedBox(height: 7),
        TextPlaceholder(color: color.lighter, width: 100),
        const SizedBox(height: 7),
        TextPlaceholder(color: color.lighter, width: 50),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Color.lerp(color.light, color.lighter, tick)),
      child:
          Row(children: [_buildIcon(), _buildDivider(), _buildDataSummary()]),
    );
  }
}

class EventSummariesPlaceHolders extends StatelessWidget {
  final Nuance color;
  final int num;

  const EventSummariesPlaceHolders({
    Key? key,
    required this.color,
    this.num = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(5),
        child: TickingBuilder(
            builder: (context, tick) => ScrollList(
                  children: List.filled(
                      num, EventSummaryPlaceholder(color: color, tick: tick)),
                  color: color,
                )));
  }
}

class EventSummary extends StatelessWidget {
  final EventDataSummary data;
  final Nuance color;

  const EventSummary({
    Key? key,
    required this.data,
    required this.color,
  }) : super(key: key);

  Widget _iconRichText(Widget icon, String text,
      {TextOverflow overflow = TextOverflow.ellipsis,
      int maxLines = 1,
      int flex = 2}) {
    final Widget result = RichText(
      maxLines: maxLines,
      overflow: overflow,
      text: TextSpan(
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: icon,
          ),
          TextSpan(
            text: " $text",
            style: TextStyle(color: color.lighter),
          ),
        ],
      ),
    );
    if (flex > 0) {
      return Expanded(flex: flex, child: result);
    }
    return result;
  }

  Widget _adminAttendesNumRow(double width) {
    String maxAttendesText =
        data.maxAttendes == null ? "" : " / ${data.maxAttendes}";
    return SizedBox(
      width: width, //beurk
      child: Row(
        children: [
          _iconRichText(
            ProfileMiniature(
              picture: data.admin.picture,
              size: 12,
            ),
            data.admin.firstName,
            flex: 3,
          ),
          _iconRichText(
              Icon(ArbennIcons.userGroup, size: 12, color: color.lighter),
              '${data.numAttendes}$maxAttendesText'),
        ],
      ),
    );
  }

  Widget _dateTimeRow(double width) {
    return SizedBox(
      width: width,
      child: Row(
        children: [
          _iconRichText(
            Icon(ArbennIcons.calendar, size: 12, color: color.lighter),
            '${data.date.day} / ${data.date.month} / ${data.date.year}',
            flex: 3,
          ),
          _iconRichText(
            Icon(ArbennIcons.clock, size: 12, color: color.lighter),
            '${data.date.hour.toString().padLeft(2, '0')}:${data.date.minute.toString().padLeft(2, '0')}',
          ),
        ],
      ),
    );
  }

  Widget _locationRow(BuildContext context, double width) {
    return SizedBox(
        width: width, //beurk
        child: _iconRichText(
            Icon(ArbennIcons.location, size: 12, color: color.lighter),
            " ${data.address.toString()}",
            flex: 0,
            maxLines: 2));
  }

  Widget _buildDataSummary(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 200;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: width + 10, //beurk
          child: Text(
            data.title,
            maxLines: 1,
            style: TextStyle(
              color: color.lighter,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: width,
          child: Tags.static(
            data.tags,
            color: color,
            fontSize: 10,
            colorTheme: ColorTheme.dark,
            maxLines: 1,
            align: TextAlign.start,
          ),
        ),
        const SizedBox(height: 2),
        _adminAttendesNumRow(width),
        const SizedBox(height: 7),
        _dateTimeRow(width),
        const SizedBox(height: 7),
        _locationRow(context, width),
      ],
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 130,
      alignment: Alignment.center,
      child: SvgPicture.network(data.iconUrl,
          color: color.lighter,
          height: 100,
          placeholderBuilder: (BuildContext context) => TickingBuilder(
                builder: (context, tick) => Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: Color.lerp(color.light, color.lighter, tick)!,
                  ),
                  width: 130,
                  height: 130,
                ),
              )),
    );
  }

  Widget _buildDivider() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      margin: const EdgeInsets.only(right: 10),
      alignment: Alignment.center,
      child: VerticalDivider(
        width: 3,
        thickness: 1,
        color: color.lighter,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 150,
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
        decoration: BoxDecoration(
          color: color.dark,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(children: [
          _buildIcon(),
          _buildDivider(),
          _buildDataSummary(context),
        ]),
      ),
      onTap: () =>
          Navigator.of(context).push(slideIn(EventPage(eventSummary: data))),
    );
  }
}

class EventSummaries extends StatelessWidget {
  final List<EventDataSummary> events;
  final Nuance color;
  final int numPlaceholders;
  final Future<void> Function()? onRefresh;

  const EventSummaries({
    Key? key,
    required this.color,
    required this.events,
    this.onRefresh,
    this.numPlaceholders = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: ScrollList(
        onRefresh: onRefresh,
        children:
            events.map((e) => EventSummary(data: e, color: color)).toList(),
        color: color,
      ),
    );
  }
}

class FutureEventSummaries extends StatelessWidget {
  final Future<List<EventDataSummary>> events;
  final Nuance color;
  final int numPlaceholders;
  final Future<void> Function()? onRefresh;

  const FutureEventSummaries({
    Key? key,
    required this.color,
    required this.events,
    this.onRefresh,
    this.numPlaceholders = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EventDataSummary>>(
      future: events,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return EventSummaries(color: color, events: snapshot.data!);
        }
        return EventSummariesPlaceHolders(color: color, num: numPlaceholders);
      },
    );
  }
}

class FutureOptionEventSummary extends StatelessWidget {
  final Future<List<EventDataSummary>?> events;
  final Nuance color;
  final int numPlaceholders;
  final Future<void> Function()? onRefresh;

  const FutureOptionEventSummary({
    Key? key,
    required this.color,
    required this.events,
    this.onRefresh,
    this.numPlaceholders = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EventDataSummary>?>(
      future: events,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null) {
            return EventSummaryNoData(color: color);
          }
          return EventSummaries(
              color: color, events: snapshot.data!, onRefresh: onRefresh);
        }
        return EventSummariesPlaceHolders(color: color, num: numPlaceholders);
      },
    );
  }
}
