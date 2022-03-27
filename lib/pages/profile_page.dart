import 'dart:async';

import 'package:arbenn/components/app_bar.dart';
import 'package:arbenn/components/page_transitions.dart';
import 'package:arbenn/components/placeholders.dart';
import 'package:arbenn/components/user_elements.dart';
import 'package:arbenn/pages/user_settings.dart';
import 'package:arbenn/utils/icons.dart';
import 'package:flutter/material.dart' hide BackButton;
import '../utils/colors.dart';
import '../components/buttons.dart';
import '../components/tabs.dart';
import '../data/user_data.dart';
import '../components/scroller.dart';
import '../components/event_summary.dart';
import '../components/tags.dart';
import '../data/event_data.dart';

class _Tabs extends StatelessWidget {
  final Nuance color;
  final bool backButton;
  final Function(BuildContext)? onEdit;
  final Widget description;
  final Widget events;
  final Widget userInfos;

  const _Tabs({
    Key? key,
    this.color = Palette.blue,
    this.backButton = false,
    this.onEdit,
    required this.description,
    required this.events,
    required this.userInfos,
  }) : super(key: key);

  _buildTabs() {
    return Expanded(
      child: Tabs(tabs: [
        TabInfos(content: description, title: "Description"),
        TabInfos(content: events, title: "Evenements"),
      ], color: color),
    );
  }

  _buildEditButton(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      child: TextButton(
        onPressed: () => onEdit!(context),
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
                userInfos,
                if (onEdit != null) _buildEditButton(context)
              ],
            ),
            _buildTabs(),
          ],
        ),
      ),
    );
  }
}

// Instant page
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
  final Future<List<EventDataSummary>?> adminEvents;

  const ProfilePage({
    Key? key,
    required this.user,
    required this.adminEvents,
    this.color = Palette.blue,
    this.backButton = false,
    this.editButton = true,
  }) : super(key: key);

  void onEdit(BuildContext context) {
    Navigator.of(context).push(slideIn(UserSettings(
      user: user,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return _Tabs(
      backButton: backButton,
      onEdit: editButton ? onEdit : null,
      description: _Description(user: user, color: color),
      events: FutureOptionEventSummary(events: adminEvents, color: color),
      userInfos: _UserInfos(user: user, color: color),
    );
  }
}

// Placeholders
class _DescriptionPlaceholder extends StatelessWidget {
  final Nuance color;
  final double tick;

  const _DescriptionPlaceholder(
      {Key? key, this.color = Palette.yellow, required this.tick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color textColor = Color.lerp(color.light, color.main, tick)!;
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
          TextPlaceholder(
            color: textColor,
            height: 15,
            width: 50,
          ),
          const SizedBox(height: 20),
          Text(
            "Bio.",
            style: TextStyle(
                color: color.darker, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          TextPlaceholder(color: textColor),
          const SizedBox(height: 4),
          TextPlaceholder(color: textColor),
          const SizedBox(height: 4),
          TextPlaceholder(color: textColor),
          const SizedBox(height: 4),
          TextPlaceholder(color: textColor)
        ],
      ),
    );
  }
}

class _UserInfosPlaceholder extends StatelessWidget {
  final Nuance color;
  final double tick;

  const _UserInfosPlaceholder(
      {Key? key, required this.color, required this.tick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color textColor = Color.lerp(color.main, color.dark, tick)!;
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          width: 180.0,
          height: 180.0,
          decoration: BoxDecoration(
            color: textColor,
            shape: BoxShape.circle,
          ),
        ),
        Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: TextPlaceholder(color: textColor, height: 20, width: 150)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              ArbennIcons.location,
              color: textColor,
            ),
            const SizedBox(width: 10),
            TextPlaceholder(color: textColor, height: 15, width: 100)
          ],
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}

class _ProfilePagePlaceholder extends StatelessWidget {
  final Nuance color;
  final bool backButton;
  final bool editButton;
  final Duration duration;

  const _ProfilePagePlaceholder({
    Key? key,
    this.color = Palette.blue,
    this.backButton = false,
    this.editButton = true,
    this.duration = const Duration(seconds: 1),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TickingBuilder(
        builder: (context, tick) => _Tabs(
              description: _DescriptionPlaceholder(
                color: color,
                tick: tick,
              ),
              events: EventSummariesPlaceHolders(color: color),
              userInfos: _UserInfosPlaceholder(
                color: color,
                tick: tick,
              ),
            ));
  }
}

class FutureProfilePage extends StatelessWidget {
  final Future<UserData?> user;
  final Nuance color;
  final bool backButton;
  final bool editButton;

  const FutureProfilePage({
    Key? key,
    required this.user,
    this.color = Palette.blue,
    this.backButton = false,
    this.editButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color.lighter,
      child: SafeArea(
        child: Scaffold(
          appBar: appBar(context, color),
          body: ColoredBox(
            color: color.lighter,
            child: FutureBuilder<UserData?>(
              future: user,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ProfilePage(
                    user: snapshot.data!,
                    adminEvents: snapshot.data!.loadAdminEvents(),
                    color: color,
                    backButton: backButton,
                    editButton: editButton,
                  );
                } else {
                  return _ProfilePagePlaceholder(
                    color: color,
                    backButton: backButton,
                    editButton: editButton,
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
