import 'package:arbenn/components/user_elements.dart';
import 'package:arbenn/pages/event_form.dart';
import 'package:flutter/material.dart' hide BackButton;
import '../utils/colors.dart';
import '../data/event_data.dart';
import '../components/app_bar.dart';
import '../components/buttons.dart';
import '../components/tabs.dart';
import '../components/tags.dart';
import '../components/scroller.dart';

class EventPage extends StatefulWidget {
  final int eventId;
  final Nuance color;

  const EventPage({
    Key? key,
    required this.eventId,
    this.color = Palette.yellow,
  }) : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late EventData _eventInfos;
  late bool _isAttende;

  @override
  void initState() {
    super.initState();
    _eventInfos = EventData.dummy();
    _isAttende = false;
  }

  Widget _participateButton() {
    return TextButton(
      onPressed: () => {
        setState(() => {_isAttende = true})
      },
      child: Container(
          child: Text("PARTICIPER",
              style: TextStyle(
                color: widget.color.lighter,
              )),
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          decoration: BoxDecoration(
              color: widget.color.darker,
              borderRadius: const BorderRadius.all(Radius.circular(5)))),
    );
  }

  Widget _cancelParticipation() {
    return TextButton(
        onPressed: () => {
              setState(() => {_isAttende = false})
            },
        child: SizedBox(
          height: 32,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.close_outlined,
                color: widget.color.darker,
              ),
              Text(
                "ANNULER",
                style: TextStyle(
                  color: widget.color.darker,
                ),
              ),
            ],
          ),
        ));
  }

  Widget _participateManage() {
    final int? remainingPlaces = _eventInfos.maxAttendes != null
        ? _eventInfos.maxAttendes! - _eventInfos.numAttendes
        : null;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: widget.color.darker)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("$remainingPlaces / ${_eventInfos.maxAttendes} places restantes",
              style: TextStyle(
                color: widget.color.darker,
              )),
          const SizedBox(height: 10),
          _isAttende ? _cancelParticipation() : _participateButton(),
        ],
      ),
    );
  }

  Widget _iconLabel(Widget icon, String label) {
    return Row(
      children: [
        icon,
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            color: widget.color.lighter,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }

  Widget _eventInfosWidget() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: widget.color.dark,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 35,
            child: _iconLabel(
                ProfileMiniature(picture: _eventInfos.admin.picture),
                "${_eventInfos.admin.firstName} "),
          ),
          SizedBox(
            height: 35,
            child: _iconLabel(
                Icon(
                  Icons.place,
                  size: 20,
                  color: widget.color.lighter,
                ),
                _eventInfos.location),
          ),
          SizedBox(
            height: 35,
            child: Row(
              children: [
                Expanded(
                  child: _iconLabel(
                    Icon(
                      Icons.calendar_today,
                      size: 20,
                      color: widget.color.lighter,
                    ),
                    '${_eventInfos.date.day.toString().padLeft(2, '0')} / ${_eventInfos.date.month.toString().padLeft(2, '0')} / ${_eventInfos.date.year}',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _iconLabel(
                    Icon(
                      Icons.timer,
                      size: 20,
                      color: widget.color.lighter,
                    ),
                    '${_eventInfos.date.hour.toString().padLeft(2, '0')}:${_eventInfos.date.minute.toString().padLeft(2, '0')}',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 35,
            child: Row(
              children: [
                Icon(
                  Icons.tag,
                  size: 20,
                  color: widget.color.lighter,
                ),
                const SizedBox(width: 3),
                Tags.static(_eventInfos.tags, color: widget.color, fontSize: 10)
              ],
            ),
          ),
          SizedBox(
            height: 35,
            child: Row(
              children: [
                Icon(
                  Icons.people,
                  size: 20,
                  color: widget.color.lighter,
                ),
                const SizedBox(width: 5),
                ProfileMiniatures(
                  pictures: _eventInfos.attendes.map((a) => a.picture).toList(),
                  size: 15,
                ),
                const SizedBox(width: 5),
                TextButton(
                  onPressed: () => {},
                  child: Text(
                    "Participants (${_eventInfos.numAttendes})",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 12,
                        color: widget.color.lighter,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _description() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: widget.color.darker)),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(style: TextStyle(color: widget.color.darker), children: [
          const TextSpan(
              text: "Description. ",
              style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: _eventInfos.description)
        ]),
      ),
    );
  }

  Widget _descriptionTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      child: ScrollList(
        shadowColor: widget.color.darker,
        children: [
          _participateManage(),
          const SizedBox(height: 45),
          _eventInfosWidget(),
          const SizedBox(height: 45),
          _description()
        ],
      ),
    );
  }

  Widget _chatTab() {
    return const Text("");
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      color: widget.color.main,
      child: Container(
        decoration: BoxDecoration(
            color: widget.color.light,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(25))),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: BackButton(color: widget.color)),
                Container(
                    alignment: Alignment.topCenter,
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      _eventInfos.title,
                      style: TextStyle(
                          color: widget.color.darker,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )),
                Container(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EventFormPage(),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 18),
                      child: Icon(
                        Icons.edit,
                        size: 24,
                        color: widget.color.darker,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: Tabs(tabs: [
                TabInfos(content: _descriptionTab(), title: "Description"),
                TabInfos(content: _chatTab(), title: "Discussions"),
              ], color: widget.color),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: widget.color.main,
      child: SafeArea(
        child: Scaffold(
          body: _buildContent(context),
          appBar: appBar(context, widget.color),
        ),
      ),
    );
  }
}
