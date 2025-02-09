import 'dart:async';
import 'package:arbenn/components/buttons.dart';
import 'package:arbenn/pages/user/_header.dart';
import 'package:arbenn/pages/user/body/_body.dart';
import 'package:arbenn/utils/errors/result.dart';
import 'package:arbenn/utils/page_transitions.dart';
import 'package:arbenn/pages/settings/user_settings.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:arbenn/data/user/user_data.dart';
import 'package:arbenn/data/event/event_data.dart';

class ProfilePage extends StatefulWidget {
  final UserData user;
  final bool backButton;
  final Function(UserData)? onEditUser;
  final Future<Result<List<EventDataSummary>>> events;

  const ProfilePage({
    super.key,
    required this.user,
    required this.events,
    this.onEditUser,
    this.backButton = false,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ScrollController _scroll;
  late bool _showTopButton;

  @override
  void initState() {
    _scroll = ScrollController();
    _showTopButton = true;
    _scroll.addListener(() {
      if (_scroll.offset > 210) {
        setState(() => _showTopButton = false);
      } else if (_scroll.offset < 200) {
        setState(() => _showTopButton = true);
      }
    });
    super.initState();
  }

  void onEdit(BuildContext context) {
    Navigator.of(context).push(
      slideIn(
        UserSettings(
          user: widget.user,
          onEditUser: widget.onEditUser!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        ProfilePageHeader(user: widget.user),
        SingleChildScrollView(
          controller: _scroll,
          physics: const ClampingScrollPhysics(),
          child: ProfilePageBody(
            user: widget.user,
            events: widget.events,
            onEdit: widget.onEditUser,
          ),
        ),
        SafeArea(
          child: Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.backButton && _showTopButton)
                  const GlassBackButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
