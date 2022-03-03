import 'package:arbenn/components/chat.dart';
import 'package:arbenn/components/user_elements.dart';
import 'package:arbenn/data/chat_data.dart';
import 'package:arbenn/data/user_data.dart';
import 'package:arbenn/pages/attende_list.dart';
import 'package:arbenn/pages/event_form.dart';
import 'package:arbenn/utils/icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide BackButton;
import '../utils/colors.dart';
import '../data/event_data.dart';
import '../components/app_bar.dart';
import '../components/buttons.dart';
import '../components/tabs.dart';
import '../components/tags.dart';
import '../components/scroller.dart';

class EventPage extends StatefulWidget {
  final String eventId;
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
  late EventDataStream _eventDataStream;
  ChatData? _currentChatData;

  @override
  void initState() {
    super.initState();
    _eventDataStream = EventDataStream(eventId: widget.eventId);
  }

  void subscribe() {
    EventData.addAttende(widget.eventId);
  }

  void unsubscribe() {
    EventData.removeAttende(widget.eventId);
  }

  bool isAttende(EventData event) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return false;
    } else {
      return event.attendes.any((attende) => attende.userId == user.uid);
    }
  }

  bool isAdmin(EventData event) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return false;
    } else {
      return event.admin.userId == user.uid;
    }
  }

  Widget _participateButton() {
    return TextButton(
      onPressed: subscribe,
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
        onPressed: unsubscribe,
        child: SizedBox(
          height: 32,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                ArbennIcons.xmark,
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

  Widget _participateManage(EventData event) {
    final int? remainingPlaces = event.maxAttendes != null
        ? event.maxAttendes! - event.numAttendes
        : null;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: widget.color.darker)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              event.maxAttendes != null
                  ? "$remainingPlaces / ${event.maxAttendes} places restantes"
                  : "${event.numAttendes} participant${event.numAttendes > 1 ? "s" : ""}",
              style: TextStyle(
                color: widget.color.darker,
              )),
          const SizedBox(height: 10),
          isAttende(event) ? _cancelParticipation() : _participateButton(),
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

  Widget _eventInfosWidget(EventData event) {
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
            child: _iconLabel(ProfileMiniature(picture: event.admin.picture),
                "${event.admin.firstName} "),
          ),
          SizedBox(
            height: 35,
            child: _iconLabel(
                Icon(
                  ArbennIcons.location,
                  size: 20,
                  color: widget.color.lighter,
                ),
                event.address.toString()),
          ),
          SizedBox(
            height: 35,
            child: Row(
              children: [
                Expanded(
                  child: _iconLabel(
                    Icon(
                      ArbennIcons.calendar,
                      size: 20,
                      color: widget.color.lighter,
                    ),
                    '${event.date.day.toString().padLeft(2, '0')} / ${event.date.month.toString().padLeft(2, '0')} / ${event.date.year}',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _iconLabel(
                    Icon(
                      ArbennIcons.clock,
                      size: 15,
                      color: widget.color.lighter,
                    ),
                    '${event.date.hour.toString().padLeft(2, '0')}:${event.date.minute.toString().padLeft(2, '0')}',
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
                  ArbennIcons.hashtag,
                  size: 20,
                  color: widget.color.lighter,
                ),
                const SizedBox(width: 3),
                Tags.static(event.tags, color: widget.color, fontSize: 10)
              ],
            ),
          ),
          SizedBox(
            height: 35,
            child: Row(
              children: [
                Icon(
                  ArbennIcons.userGroup,
                  size: 15,
                  color: widget.color.lighter,
                ),
                const SizedBox(width: 10),
                ProfileMiniatures(
                  pictures: event.attendes.map((a) => a.picture).toList(),
                  size: 15,
                ),
                const SizedBox(width: 5),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AttendeList(
                                attendes: event.attendes,
                                color: widget.color)));
                  },
                  child: Text(
                    "Participants (${event.numAttendes})",
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

  Widget _description(String description) {
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
          TextSpan(text: description)
        ]),
      ),
    );
  }

  Widget _descriptionTab(EventData event) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      child: ScrollList(
        shadowColor: widget.color.darker,
        children: [
          _participateManage(event),
          const SizedBox(height: 15),
          _eventInfosWidget(event),
          if (event.description != "") ...[
            const SizedBox(height: 15),
            _description(event.description)
          ]
        ],
      ),
    );
  }

  Widget _chatTab(EventData event) {
    if (_currentChatData == null) {
      User? user = FirebaseAuth.instance.currentUser;
      return Chat(
        chatData: ChatData(
          chatId: isAdmin(event) ? event.eventId : user!.uid,
          eventId: event.eventId,
        ),
        sender: UserSumarryData.currentUser(),
      );
    } else {
      return Chat(
        chatData: _currentChatData!,
        sender: UserSumarryData.currentUser(),
      );
    }
  }

  Future<void> showChatSelector(List<ChatSummary> chats) {
    return showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: chats.length < 5 ? chats.length * 50 + 25 : 270,
            decoration: BoxDecoration(
                color: widget.color.light,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                )),
            padding: const EdgeInsets.all(10),
            child: Center(
              child: ScrollList(
                shadowColor: widget.color.darker,
                children: chats
                    .map(
                      (chatSummary) => SizedBox(
                        height: 50,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() => _currentChatData = ChatData(
                                chatId: chatSummary.chatId,
                                eventId: widget.eventId));
                          },
                          child: Row(
                            children: [
                              chatSummary.image,
                              const SizedBox(width: 10),
                              Text(chatSummary.name,
                                  style: TextStyle(
                                      color: widget.color.darker,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          );
        });
  }

  Widget _buildTabs(EventData event) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User is null and shouldn't be");
    }
    final ChatSummary eventChatSummary = ChatSummary(
        chatId: event.eventId,
        eventId: event.eventId,
        name: "tout le monde",
        image: Icon(
          ArbennIcons.userGroup,
          color: widget.color.darker,
          size: 25,
        ));
    final ChatSummary adminChatSummary = ChatSummary(
        chatId: user.uid,
        eventId: event.eventId,
        name: event.admin.firstName,
        image: ProfileMiniature(picture: event.admin.picture, size: 30));
    late Stream<List<ChatSummary>> chats;
    if (isAdmin(event)) {
      chats = ChatData.listEventChats(event.eventId);
    } else if (isAttende(event)) {
      chats = Stream.value([eventChatSummary, adminChatSummary]);
    } else {
      chats = Stream.value([adminChatSummary]);
    }
    return StreamBuilder<List<ChatSummary>>(
        stream: chats,
        builder: (context, snapshot) {
          late Future<void> Function() selectChat;
          if (snapshot.hasData) {
            selectChat = () async {
              if (snapshot.data!.length > 1) {
                return showChatSelector(snapshot.data!);
              }
            };
          } else {
            selectChat = () async => {};
          }
          return Expanded(
            child: Tabs(tabs: [
              TabInfos(content: _descriptionTab(event), title: "Description"),
              TabInfos(
                  content: _chatTab(event),
                  title: "Discussions",
                  onTap: selectChat),
            ], color: widget.color),
          );
        });
  }

  Widget _buildContent(BuildContext context, EventData event) {
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
                      event.title,
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
                        builder: (context) => EventFormPage(
                          event: event,
                        ),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 18),
                      child: Icon(
                        ArbennIcons.pencil,
                        size: 20,
                        color: widget.color.darker,
                      ),
                    ),
                  ),
                )
              ],
            ),
            _buildTabs(event)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _eventDataStream.event,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ColoredBox(
            color: widget.color.main,
            child: SafeArea(
              child: Scaffold(
                body: _buildContent(context, snapshot.data as EventData),
                appBar: appBar(context, widget.color),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text("error");
        } else {
          return Text("waiting");
        }
      },
    );
  }
}
