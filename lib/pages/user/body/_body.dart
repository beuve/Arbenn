import 'package:arbenn/data/event/event_data.dart';
import 'package:arbenn/data/user/user_data.dart';
import 'package:arbenn/pages/user/body/_attended_events.dart';
import 'package:arbenn/pages/user/body/_interests.dart';
import 'package:arbenn/pages/user/body/_user_infos.dart';
import 'package:arbenn/utils/errors/result.dart';
import 'package:flutter/material.dart';

class ProfilePageBody extends StatelessWidget {
  final UserData user;
  final Future<Result<List<EventDataSummary>>> events;
  final Function(UserData)? onEdit;

  const ProfilePageBody({
    super.key,
    required this.user,
    required this.events,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    double paddingTop = MediaQuery.of(context).padding.top;
    return Container(
      margin: EdgeInsets.only(top: 230 + paddingTop),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfilePageUserInfos(
            user: user,
            onEdit: onEdit,
          ),
          const SizedBox(height: 20),
          ProfilePageInterests(user: user),
          const SizedBox(height: 20),
          ProfilePageAttendedEvents(events: events),
        ],
      ),
    );
  }
}
