import 'package:arbenn/components/scroller.dart';
import 'package:arbenn/utils/icons.dart';
import 'package:flutter/material.dart' hide IconButton, BackButton;
import '../utils/colors.dart';
import '../data/event_data.dart';
import 'tags.dart';
import '../pages/event_page.dart';
import 'user_elements.dart';
import 'dart:async';

class EventSummariesPlaceHolders extends StatefulWidget {
  final Nuance color;
  final int num;

  const EventSummariesPlaceHolders(
      {Key? key, required this.color, this.num = 2})
      : super(key: key);

  @override
  State<EventSummariesPlaceHolders> createState() =>
      _EventSummariesPlaceHoldersState();
}

class _EventSummariesPlaceHoldersState extends State<EventSummariesPlaceHolders>
    with TickerProviderStateMixin {
  late Timer _timer;
  late Color _color;

  @override
  initState() {
    super.initState();
    _color = widget.color.light;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (t.tick % 2 == 0) {
        setState(() => _color = widget.color.lighter);
      } else {
        setState(() => _color = widget.color.light);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(
        () => _color = widget.color.lighter)); // Start the animation immediatly
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget _buildDivider() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      margin: const EdgeInsets.only(right: 10),
      alignment: Alignment.center,
      child: VerticalDivider(
        width: 3,
        thickness: 1,
        color: widget.color.lighter,
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
          color: widget.color.lighter,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }

  Widget _fakeLine({IconData? icon, double width = 60}) {
    return Row(children: [
      if (icon != null) Icon(icon, size: 12, color: widget.color.lighter),
      Container(
        height: 10,
        width: width,
        decoration: BoxDecoration(
          color: widget.color.lighter,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
      )
    ]);
  }

  Widget _buildDataSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        _fakeLine(width: 150),
        const SizedBox(height: 42),
        _fakeLine(width: 110),
        const SizedBox(height: 7),
        _fakeLine(width: 70),
        const SizedBox(height: 7),
        _fakeLine(width: 100),
        const SizedBox(height: 7),
        _fakeLine(width: 50),
      ],
    );
  }

  Widget _dummy() {
    return AnimatedContainer(
      height: 150,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(
        color: _color,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      duration: const Duration(seconds: 1),
      curve: Curves.linear,
      child:
          Row(children: [_buildIcon(), _buildDivider(), _buildDataSummary()]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScrollList(
        children: List.filled(widget.num, _dummy()),
        shadowColor: widget.color.darker);
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

  Widget _adminAttendesNumRow() {
    return Row(
      children: [
        ProfileMiniature(picture: data.admin.picture, size: 12),
        const SizedBox(width: 5),
        Text(
          data.admin.firstName,
          style: TextStyle(color: color.lighter),
        ),
        const SizedBox(width: 15),
        Icon(ArbennIcons.userGroup, size: 12, color: color.lighter),
        const SizedBox(width: 5),
        Text(
          '${data.numAttendes} / ${data.maxAttendes}',
          style: TextStyle(color: color.lighter),
        ),
      ],
    );
  }

  Widget _dateTimeRow() {
    return Row(
      children: [
        Icon(ArbennIcons.calendar, size: 12, color: color.lighter),
        const SizedBox(width: 5),
        SizedBox(
          width: 89,
          child: Text(
            '${data.date.day} / ${data.date.month} / ${data.date.year}',
            style: TextStyle(color: color.lighter),
          ),
        ),
        const SizedBox(width: 15),
        Icon(ArbennIcons.clock, size: 12, color: color.lighter),
        const SizedBox(width: 5),
        Text(
          '${data.date.hour.toString().padLeft(2, '0')}:${data.date.minute.toString().padLeft(2, '0')}',
          style: TextStyle(color: color.lighter),
        ),
      ],
    );
  }

  Widget _locationRow() {
    return Row(
      children: [
        Icon(ArbennIcons.location, size: 12, color: color.lighter),
        const SizedBox(width: 5),
        Text(
          data.location,
          style: TextStyle(color: color.lighter),
        ),
      ],
    );
  }

  Widget _buildDataSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.title,
          maxLines: 2,
          style: TextStyle(color: color.lighter, fontSize: 15),
          overflow: TextOverflow.clip,
          softWrap: false,
        ),
        const SizedBox(height: 12),
        Tags.static(data.tags, color: color, fontSize: 10),
        const SizedBox(height: 2),
        _adminAttendesNumRow(),
        const SizedBox(height: 7),
        _dateTimeRow(),
        const SizedBox(height: 7),
        _locationRow(),
      ],
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 130,
      alignment: Alignment.center,
      child: Icon(
        data.icon,
        size: 100,
        color: color.lighter,
      ),
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
    return TextButton(
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
          _buildDataSummary(),
        ]),
      ),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventPage(eventId: data.eventId),
        ),
      ),
    );
  }
}

class EventSummaries extends StatelessWidget {
  final Future<List<EventDataSummary>> events;
  final Nuance color;
  final int numPlaceholders;

  const EventSummaries({
    Key? key,
    required this.color,
    required this.events,
    this.numPlaceholders = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EventDataSummary>>(
      future: events,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ScrollList(
              children: snapshot.data!
                  .map((e) => EventSummary(data: e, color: color))
                  .toList(),
              shadowColor: color.darker);
        }
        return EventSummariesPlaceHolders(color: color, num: numPlaceholders);
      },
    );
  }
}
