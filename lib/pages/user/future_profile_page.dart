// Future Page
import 'package:arbenn/data/event/event_data.dart';
import 'package:arbenn/data/user/user_data.dart';
import 'package:arbenn/pages/user/_user_page_placeholder.dart';
import 'package:arbenn/pages/user/user_page.dart';
import 'package:arbenn/data/user/authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FutureProfilePage extends StatelessWidget {
  final Future<UserData?> user;
  final bool backButton;
  final Function(UserData)? onEditUser;

  const FutureProfilePage({
    super.key,
    required this.user,
    this.onEditUser,
    this.backButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final creds =
        Provider.of<CredentialsNotifier>(context, listen: false).value!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<UserData?>(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ProfilePage(
              user: snapshot.data!,
              events: EventDataSummary.loadFutureAttendesEvents(
                snapshot.data!.userId,
                creds: creds,
              ),
              backButton: backButton,
              onEditUser: onEditUser,
            );
          } else {
            return ProfilePagePlaceholder(
              backButton: backButton,
              editButton: onEditUser != null,
            );
          }
        },
      ),
    );
  }
}
