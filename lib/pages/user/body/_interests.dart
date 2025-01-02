import 'package:arbenn/components/tags.dart';
import 'package:arbenn/data/user/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePageInterests extends StatelessWidget {
  final UserData user;

  const ProfilePageInterests({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.interests,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        StaticTags(
          user.tags
              .map(
                (t) => t.label,
              )
              .toList(),
          fontSize: 13,
        ),
      ],
    );
  }
}
