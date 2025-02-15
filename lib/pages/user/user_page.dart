import 'dart:async';
import 'package:arbenn/components/overlay.dart';
import 'package:arbenn/pages/user/body/_body.dart';
import 'package:arbenn/utils/page_transitions.dart';
import 'package:arbenn/pages/settings/user_settings.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:arbenn/data/user/user_data.dart';
import 'package:arbenn/data/event/event_data.dart';

class ProfilePage extends StatelessWidget {
  final UserData user;
  final bool backButton;
  final Function(UserData)? onEditUser;
  final Future<List<EventDataSummary>?> events;

  const ProfilePage({
    super.key,
    required this.user,
    required this.events,
    this.onEditUser,
    this.backButton = false,
  });

  void onEdit(BuildContext context) {
    Navigator.of(context).push(
      slideIn(
        UserSettings(
          user: user,
          onEditUser: onEditUser!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (user.pictureUrl != null) {
      return FullPageOverlayWithImage(
        imageUrl: user.pictureUrl!,
        showBackButton: backButton,
        body: ProfilePageBody(
          user: user,
          events: events,
          onEdit: onEditUser,
        ),
      );
    } else {
      return FullPageOverlay(
        title: user.firstName,
        body: ProfilePageBody(
          user: user,
          events: events,
          onEdit: onEditUser,
        ),
      );
    }
  }
}
