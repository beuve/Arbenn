import 'package:flutter/material.dart' hide IconButton, BackButton;
import '../utils/colors.dart';
import '../data/event_data.dart';
import 'tags.dart';

class EventSummary extends StatelessWidget {
  final EventSumarryData data;
  final Nuance color;

  const EventSummary({
    Key? key,
    required this.data,
    required this.color,
  }) : super(key: key);

  Widget _adminAttendesNumRow() {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: data.admin.picture,
            ),
          ),
        ),
        const SizedBox(width: 5),
        Container(
          child: Text(
            data.admin.firstName,
            style: TextStyle(color: color.lighter),
          ),
        ),
        const SizedBox(width: 15),
        Icon(Icons.people_alt, size: 12, color: color.lighter),
        const SizedBox(width: 5),
        Container(
          child: Text(
            '${data.numAttendes} / ${data.maxAttendes}',
            style: TextStyle(color: color.lighter),
          ),
        ),
      ],
    );
  }

  Widget _dateTimeRow() {
    return Row(
      children: [
        Icon(Icons.calendar_today, size: 12, color: color.lighter),
        const SizedBox(width: 5),
        SizedBox(
          width: 89,
          child: Text(
            '${data.date.day} / ${data.date.month} / ${data.date.year}',
            style: TextStyle(color: color.lighter),
          ),
        ),
        const SizedBox(width: 15),
        Icon(Icons.timer, size: 12, color: color.lighter),
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
        Icon(Icons.location_city, size: 12, color: color.lighter),
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
        tags(data.tags, foregroundColor: color.lighter, fontSize: 10),
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
      onPressed: () {},
    );
  }
}