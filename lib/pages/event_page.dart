import 'package:arbenn/components/chat.dart';
import 'package:arbenn/components/page_transitions.dart';
import 'package:arbenn/components/placeholders.dart';
import 'package:arbenn/components/user_elements.dart';
import 'package:arbenn/data/chat_data.dart';
import 'package:arbenn/data/locations_data.dart';
import 'package:arbenn/data/tags_data.dart';
import 'package:arbenn/data/user_data.dart';
import 'package:arbenn/pages/attende_list.dart';
import 'package:arbenn/pages/event_form.dart';
import 'package:arbenn/pages/profile_page.dart';
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

class _EventInfos extends StatelessWidget {
  final UserSumarryData admin;
  final Address address;
  final DateTime date;
  final List<TagData> tags;
  final List<UserSumarryData>? attendes;
  final int numAttendes;
  final Nuance color;

  const _EventInfos(
      {Key? key,
      required this.admin,
      required this.address,
      required this.date,
      required this.tags,
      required this.numAttendes,
      this.attendes,
      required this.color})
      : super(key: key);

  Widget _iconLabel(Widget icon, String label) {
    return Row(
      children: [
        icon,
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            color: color.lighter,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }

  Widget _adminInfos(BuildContext context) {
    return TextButton(
        onPressed: () => Navigator.of(context).push(slideIn(FutureProfilePage(
            backButton: true,
            editButton: false,
            user: UserData.loadFromUserId(admin.userId)))),
        child: _iconLabel(
            ProfileMiniature(picture: admin.picture), admin.firstName));
  }

  Widget _location() {
    return _iconLabel(
        Icon(
          ArbennIcons.location,
          size: 20,
          color: color.lighter,
        ),
        address.toString());
  }

  Widget _dateTime() {
    return Row(
      children: [
        Expanded(
          child: _iconLabel(
            Icon(
              ArbennIcons.calendar,
              size: 20,
              color: color.lighter,
            ),
            '${date.day.toString().padLeft(2, '0')} / ${date.month.toString().padLeft(2, '0')} / ${date.year}',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _iconLabel(
            Icon(
              ArbennIcons.clock,
              size: 15,
              color: color.lighter,
            ),
            '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
          ),
        ),
      ],
    );
  }

  Widget _tags() {
    return Row(
      children: [
        Icon(
          ArbennIcons.hashtag,
          size: 20,
          color: color.lighter,
        ),
        const SizedBox(width: 3),
        Tags.static(tags,
            color: color, fontSize: 12, colorTheme: ColorTheme.dark)
      ],
    );
  }

  List<Widget> _attendesList(
      BuildContext context, List<UserSumarryData> attendes) {
    return [
      ProfileMiniatures(
        pictures: attendes.map((a) => a.picture).toList(),
        size: 15,
      ),
      const SizedBox(width: 5),
      TextButton(
        onPressed: () {
          Navigator.of(context)
              .push(slideIn(AttendeList(attendes: attendes, color: color)));
        },
        child: Text(
          "Participants ($numAttendes)",
          style: TextStyle(
              decoration: TextDecoration.underline,
              fontSize: 12,
              color: color.lighter,
              fontWeight: FontWeight.bold),
        ),
      )
    ];
  }

  Widget _attendes(BuildContext context) {
    return Row(
      children: [
        Icon(
          ArbennIcons.userGroup,
          size: 15,
          color: color.lighter,
        ),
        const SizedBox(width: 10),
        if (attendes != null) ..._attendesList(context, attendes!),
        if (attendes == null) TextPlaceholder(color: color.light)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.dark,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 35, child: _adminInfos(context)),
          SizedBox(height: 35, child: _location()),
          SizedBox(height: 35, child: _dateTime()),
          SizedBox(height: 35, child: _tags()),
          SizedBox(height: 35, child: _attendes(context)),
        ],
      ),
    );
  }
}

class _ManageParticipate extends StatelessWidget {
  final EventData event;
  final Nuance color;

  const _ManageParticipate({Key? key, required this.event, required this.color})
      : super(key: key);

  void subscribe() {
    EventData.addAttende(event.eventId);
  }

  void unsubscribe() {
    EventData.removeAttende(event.eventId);
  }

  bool isAttende() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return false;
    } else {
      return event.attendes.any((attende) => attende.userId == user.uid);
    }
  }

  Widget _participateButton() {
    return TextButton(
      onPressed: subscribe,
      child: Container(
          child: Text("PARTICIPER",
              style: TextStyle(
                color: color.lighter,
              )),
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          decoration: BoxDecoration(
              color: color.darker,
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
                color: color.darker,
              ),
              Text(
                "ANNULER",
                style: TextStyle(
                  color: color.darker,
                ),
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final int? remainingPlaces = event.maxAttendes != null
        ? event.maxAttendes! - event.numAttendes
        : null;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: color.darker)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              event.maxAttendes != null
                  ? "$remainingPlaces / ${event.maxAttendes} places restantes"
                  : "${event.numAttendes} participant${event.numAttendes > 1 ? "s" : ""}",
              style: TextStyle(
                color: color.darker,
              )),
          const SizedBox(height: 10),
          isAttende() ? _cancelParticipation() : _participateButton(),
        ],
      ),
    );
  }
}

class _Description extends StatelessWidget {
  final String description;
  final Nuance color;

  const _Description({Key? key, required this.description, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: color.darker)),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(style: TextStyle(color: color.darker), children: [
          const TextSpan(
              text: "Description. ",
              style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: description)
        ]),
      ),
    );
  }
}

class _DescriptionTab extends StatelessWidget {
  final EventData? event;
  final Nuance color;
  final UserSumarryData admin;
  final Address address;
  final DateTime date;
  final List<TagData> tags;
  final List<UserSumarryData>? attendes;
  final String? description;
  final int numAttendes;

  const _DescriptionTab({
    Key? key,
    this.event,
    required this.color,
    required this.admin,
    required this.address,
    required this.date,
    required this.tags,
    required this.numAttendes,
    this.description,
    this.attendes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      child: ScrollList(
        color: color,
        children: [
          if (event != null) _ManageParticipate(event: event!, color: color),
          const SizedBox(height: 15),
          _EventInfos(
            admin: admin,
            address: address,
            date: date,
            tags: tags,
            attendes: attendes,
            numAttendes: numAttendes,
            color: color,
          ),
          if (description != null && description != "") ...[
            const SizedBox(height: 15),
            _Description(description: description!, color: color)
          ]
        ],
      ),
    );
  }
}

class _ChatTab extends StatelessWidget {
  final String eventId;
  final UserSumarryData admin;
  final Nuance color;
  final ChatData? chatData;

  const _ChatTab(
      {Key? key,
      required this.eventId,
      required this.chatData,
      required this.admin,
      required this.color})
      : super(key: key);

  bool isAdmin(String userId) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return false;
    } else {
      return admin.userId == userId;
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Chat(
      chatData: chatData ??
          ChatData(
            chatId: isAdmin(user!.uid) ? eventId : user.uid,
            eventId: eventId,
          ),
      sender: UserSumarryData.currentUser(),
    );
  }
}

class EventPage extends StatefulWidget {
  final EventDataSummary eventSummary;
  final Nuance color;

  const EventPage({
    Key? key,
    required this.eventSummary,
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
    _eventDataStream = EventDataStream(eventId: widget.eventSummary.eventId);
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

  Widget _chatButton(ChatSummary chatSummary) {
    return SizedBox(
      height: 50,
      child: TextButton(
        onPressed: () {
          Navigator.pop(context);
          setState(() => _currentChatData = ChatData(
              chatId: chatSummary.chatId,
              eventId: widget.eventSummary.eventId));
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
    );
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
                color: widget.color,
                children: chats
                    .map((chatSummary) => _chatButton(chatSummary))
                    .toList(),
              ),
            ),
          );
        });
  }

  Widget _buildTabs({
    required String eventId,
    required UserSumarryData admin,
    String? description,
    required address,
    required date,
    required tags,
    required numAttendes,
    attendes,
    EventData? event,
  }) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User is null and shouldn't be");
    }
    final ChatSummary eventChatSummary = ChatSummary(
        chatId: eventId,
        eventId: eventId,
        name: "tout le monde",
        image: Icon(
          ArbennIcons.userGroup,
          color: widget.color.darker,
          size: 25,
        ));
    final ChatSummary adminChatSummary = ChatSummary(
        chatId: user.uid,
        eventId: eventId,
        name: admin.firstName,
        image: ProfileMiniature(picture: admin.picture, size: 30));
    late Stream<List<ChatSummary>> chats;
    if (event != null && isAdmin(event)) {
      chats = ChatData.listEventChats(eventId);
    } else if (event != null && isAttende(event)) {
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
              TabInfos(
                  content: _DescriptionTab(
                    admin: admin,
                    description: description,
                    event: event,
                    color: widget.color,
                    numAttendes: numAttendes,
                    tags: tags,
                    date: date,
                    address: address,
                    attendes: attendes,
                  ),
                  title: "Description"),
              TabInfos(
                  content: _ChatTab(
                      eventId: eventId,
                      admin: admin,
                      color: widget.color,
                      chatData: _currentChatData),
                  title: "Discussions",
                  onTap: selectChat),
            ], color: widget.color),
          );
        });
  }

  Widget _buildHeader(String title, [EventData? event]) {
    return Stack(
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
              title,
              style: TextStyle(
                  color: widget.color.darker,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            )),
        if (event != null && isAdmin(event))
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                child: Icon(
                  ArbennIcons.pencil,
                  size: 20,
                  color: widget.color.darker,
                ),
              ),
            ),
          )
      ],
    );
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
            _buildHeader(event.title, event),
            _buildTabs(
              eventId: event.eventId,
              admin: event.admin,
              description: event.description,
              event: event,
              numAttendes: event.numAttendes,
              tags: event.tags,
              date: event.date,
              attendes: event.attendes,
              address: event.address,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildContentFromEventSummary(
      BuildContext context, EventDataSummary event) {
    return Container(
      color: widget.color.main,
      child: Container(
        decoration: BoxDecoration(
            color: widget.color.light,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(25))),
        child: Column(
          children: [
            _buildHeader(event.title),
            _buildTabs(
              eventId: event.eventId,
              admin: event.admin,
              numAttendes: event.numAttendes,
              tags: event.tags,
              date: event.date,
              address: event.address,
            )
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
          appBar: appBar(context, widget.color),
          body: StreamBuilder(
            stream: _eventDataStream.event,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return _buildContent(context, snapshot.data as EventData);
              } else if (snapshot.hasError) {
                return const Text("error");
              } else {
                return _buildContentFromEventSummary(
                    context, widget.eventSummary);
              }
            },
          ),
        ),
      ),
    );
  }
}
