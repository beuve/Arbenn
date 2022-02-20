import 'package:arbenn/utils/icons.dart';
import 'package:flutter/material.dart' hide BackButton;
import '../utils/colors.dart';
import '../components/buttons.dart';
import '../components/tabs.dart';
import '../data/user_data.dart';
import '../components/scroller.dart';
import '../components/event_summary.dart';
import '../components/tags.dart';
import 'user_settings.dart';
import '../data/event_data.dart';

class ProfilePage extends StatelessWidget {
  final UserData user;
  final Nuance color;
  final bool backButton;
  final bool editButton;
  final Future<List<EventData>> adminEvents;

  const ProfilePage({
    Key? key,
    required this.user,
    required this.adminEvents,
    this.color = Palette.blue,
    this.backButton = false,
    this.editButton = true,
  }) : super(key: key);

  static ProfilePage dummy() {
    return ProfilePage(
      user: UserData.dummy(),
      adminEvents: (() async => [
            EventData.dummy(),
            EventData.dummy(),
            EventData.dummy(),
          ])(),
    );
  }

  Widget _buildEvents(BuildContext context) {
    return FutureBuilder(
      future: adminEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return ScrollList(
            shadowColor: color.darker,
            children: (snapshot.data! as List<EventData>)
                .map((e) => EventSummary(data: e, color: color))
                .toList(),
            onRefresh: () async => print("test"),
          );
        } else {
          return Text("breath waiting");
        }
      },
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(10),
      child: ScrollList(
        shadowColor: color.darker,
        children: [
          Text(
            "Centres d'interets",
            style: TextStyle(
                color: color.darker, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            alignment: Alignment.centerLeft,
            child: Tags.static(
              user.tags,
              color: color,
              active: true,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Bio.",
            style: TextStyle(
                color: color.darker, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Text(
            user.description,
            textAlign: TextAlign.justify,
            overflow: TextOverflow.clip,
            style: TextStyle(color: color.darker, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      color: color.main,
      child: Container(
        decoration: BoxDecoration(
            color: color.light,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(25))),
        child: Column(
          children: [
            Stack(
              children: [
                if (backButton)
                  Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: BackButton(color: color)),
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: user.picture ??
                              const AssetImage(
                                  'assets/images/user_placeholder.png'),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        "${user.firstName} ${user.lastName}, ${user.age} ans",
                        style: TextStyle(
                            color: color.darker,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          ArbennIcons.location,
                          color: color.darker,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          user.location,
                          style: TextStyle(
                              color: color.darker,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
                if (editButton)
                  Container(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserSettings(
                                  userId: user.userId,
                                )),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 18),
                        child: Icon(
                          ArbennIcons.vdots,
                          size: 24,
                          color: color.darker,
                        ),
                      ),
                    ),
                  )
              ],
            ),
            Expanded(
              child: Tabs(tabs: [
                TabInfos(
                    content: _buildDescription(context), title: "Description"),
                TabInfos(content: _buildEvents(context), title: "Evenements"),
              ], color: color),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }
}
