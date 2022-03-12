import 'package:arbenn/components/user_elements.dart';
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

class _Description extends StatelessWidget {
  final UserData user;
  final Nuance color;

  const _Description(
      {Key? key, required this.user, this.color = Palette.yellow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}

class _UserInfos extends StatelessWidget {
  final UserData user;
  final Nuance color;

  const _UserInfos({Key? key, required this.user, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        ProfileMiniature(picture: user.picture, size: 180),
        Container(
          alignment: Alignment.topCenter,
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            "${user.firstName} ${user.lastName}, ${user.age} ans",
            style: TextStyle(
                color: color.darker, fontSize: 20, fontWeight: FontWeight.bold),
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
              user.location.toString(),
              style: TextStyle(
                  color: color.darker,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}

class ProfilePage extends StatelessWidget {
  final UserData user;
  final Nuance color;
  final bool backButton;
  final bool editButton;
  final Future<List<EventDataSummary>> adminEvents;

  const ProfilePage({
    Key? key,
    required this.user,
    required this.adminEvents,
    this.color = Palette.blue,
    this.backButton = false,
    this.editButton = true,
  }) : super(key: key);

  _buildEditButton(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      child: TextButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => UserSettings(
              user: user,
            ),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Icon(
            ArbennIcons.vdots,
            size: 24,
            color: color.darker,
          ),
        ),
      ),
    );
  }

  _buildBackButton() {
    return Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: BackButton(color: color));
  }

  _buildTabs() {
    return Expanded(
      child: Tabs(tabs: [
        TabInfos(
            content: _Description(user: user, color: color),
            title: "Description"),
        TabInfos(
            content: FutureEventSummaries(events: adminEvents, color: color),
            title: "Evenements"),
      ], color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                if (backButton) _buildBackButton(),
                _UserInfos(user: user, color: color),
                if (editButton) _buildEditButton(context)
              ],
            ),
            _buildTabs(),
          ],
        ),
      ),
    );
  }
}
