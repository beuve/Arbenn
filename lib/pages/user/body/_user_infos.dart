import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:arbenn/components/buttons.dart';
import 'package:arbenn/data/user/user_data.dart';
import 'package:arbenn/pages/settings/user_settings.dart';
import 'package:arbenn/pages/user/body/_location.dart';
import 'package:flutter/material.dart';

class ProfilePageUserInfos extends StatelessWidget {
  final UserData user;
  final Function(UserData)? onEdit;

  const ProfilePageUserInfos({
    super.key,
    required this.user,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (onEdit != null)
          Container(
            alignment: Alignment.topRight,
            child: SquareButton(
              icon: AkarIcons.three_line_horizontal,
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserSettings(
                      user: user,
                      onEditUser: onEdit!,
                    ),
                  ),
                );
              },
            ),
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 35,
              child: Text(
                "${user.firstName} ${user.lastName}",
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            ProfilePageLocation(user: user),
            if (user.description != '') ...[
              const SizedBox(height: 10),
              Text(
                user.description,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ],
        )
      ],
    );
  }
}
