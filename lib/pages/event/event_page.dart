import 'package:arbenn/components/buttons.dart';
import 'package:arbenn/pages/event/body/_body.dart';
import 'package:arbenn/pages/event/_header.dart';
import 'package:arbenn/data/user/user_data.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:arbenn/data/event/event_data.dart';
import 'package:provider/provider.dart';
import 'package:arbenn/data/user/authentication.dart';

class EventPage extends StatefulWidget {
  final EventData event;
  final UserData currentUser;
  final String? imageUrl;
  final Function() onEdit;

  const EventPage({
    super.key,
    required this.event,
    required this.currentUser,
    required this.onEdit,
    this.imageUrl,
  });

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late EventData _currentEvent;
  late ScrollController _scroll;
  late bool _showBackButton;
  ImageProvider? image;

  @override
  void initState() {
    _currentEvent = widget.event;
    _scroll = ScrollController();
    _showBackButton = true;
    _scroll.addListener(() {
      if (_scroll.offset > 170) {
        setState(() => _showBackButton = false);
      } else if (_scroll.offset < 160) {
        setState(() => _showBackButton = true);
      }
    });
    super.initState();
  }

  void setEvent(EventData event) {
    setState(() => _currentEvent = event);
    widget.onEdit();
  }

  addAttende() async {
    final creds =
        Provider.of<CredentialsNotifier>(context, listen: false).value!;
    await _currentEvent.addAttende(widget.currentUser.summary(), creds: creds);
    setState(() => _currentEvent = _currentEvent);
    widget.onEdit();
  }

  removeAttende() async {
    final creds =
        Provider.of<CredentialsNotifier>(context, listen: false).value!;
    await _currentEvent.removeAttende(creds.userId, creds: creds);
    setState(() => _currentEvent = _currentEvent);
    widget.onEdit();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          EventPageHeader(
            event: _currentEvent,
            imageUrl: widget.imageUrl,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              controller: _scroll,
              physics: const ClampingScrollPhysics(),
              child: EventPageBody(
                event: _currentEvent,
                currentUser: widget.currentUser,
                addAttende: addAttende,
                removeAttende: removeAttende,
                setEvent: setEvent,
              ),
            ),
          ),
          if (_showBackButton)
            SafeArea(
              child: Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 10),
                child: const GlassBackButton(),
              ),
            ),
        ],
      ),
    );
  }
}
