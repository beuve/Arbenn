import 'package:arbenn/components/overlay.dart';
import 'package:arbenn/pages/event/body/_body.dart';
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
  ImageProvider? image;

  @override
  void initState() {
    _currentEvent = widget.event;
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
    if (widget.imageUrl != null) {
      return FullPageOverlayWithImage(
        imageUrl: widget.imageUrl!,
        body: EventPageBody(
          event: _currentEvent,
          currentUser: widget.currentUser,
          addAttende: addAttende,
          removeAttende: removeAttende,
          setEvent: setEvent,
        ),
      );
    } else {
      return FullPageOverlay(
        title: _currentEvent.title,
        body: EventPageBody(
          event: _currentEvent,
          showTitle: false,
          currentUser: widget.currentUser,
          addAttende: addAttende,
          removeAttende: removeAttende,
          setEvent: setEvent,
        ),
      );
    }
  }
}
