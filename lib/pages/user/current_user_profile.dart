import 'package:arbenn/data/event/event_data.dart';
import 'package:arbenn/data/user/user_data.dart';
import 'package:arbenn/pages/user/user_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrentUserProfilePage extends StatelessWidget {
  final bool backButton;

  const CurrentUserProfilePage({
    super.key,
    this.backButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer2<UserDataNotifier, AttendeEventsNotifier>(
          builder: (context, user, events, _) {
        return ProfilePage(
          user: user.value,
          events: events.value.then((events) =>
              events?.where((e) => e.date.isAfter(DateTime.now())).toList()),
          backButton: backButton,
          onEditUser: (u) => Provider.of<UserDataNotifier>(
            context,
            listen: false,
          ).value = u,
        );
      }),
    );
  }
}
