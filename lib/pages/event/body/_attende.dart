import 'package:arbenn/components/profile_miniature.dart';
import 'package:arbenn/data/event/event_data.dart';
import 'package:arbenn/data/user/user_data.dart';
import 'package:arbenn/pages/event/_utils.dart';
import 'package:arbenn/pages/user/future_profile_page.dart';
import 'package:arbenn/utils/errors/result.dart';
import 'package:arbenn/utils/page_transitions.dart';
import 'package:arbenn/data/user/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Attende extends StatelessWidget {
  final EventData event;
  final UserSumarryData user;
  final Credentials creds;

  const Attende({
    super.key,
    required this.event,
    required this.user,
    required this.creds,
  });

  @override
  Widget build(BuildContext context) {
    final admin = isAdmin(context, event);
    final role = admin
        ? AppLocalizations.of(context)!.admin
        : AppLocalizations.of(context)!.attende;
    return InkWell(
      onTap: () => Navigator.of(context).push(slideIn(FutureProfilePage(
          backButton: true,
          user:
              UserData.loadFromUserId(user.userId, creds: creds).toOption()))),
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        child: Row(
          children: [
            ProfileMiniature(
              pictureUrl: user.pictureUrl,
              size: 50,
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.firstName),
                Text(role, style: const TextStyle(color: Colors.black38))
              ],
            )
          ],
        ),
      ),
    );
  }
}
