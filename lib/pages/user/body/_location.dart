import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:arbenn/data/user/user_data.dart';
import 'package:flutter/material.dart';

class ProfilePageLocation extends StatelessWidget {
  final UserData user;

  const ProfilePageLocation({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Icon(
          AkarIcons.location,
          color: Colors.grey,
          size: 13,
        ),
        const SizedBox(width: 5),
        Text(
          "${user.location.city} · ${user.age} ans",
          style: const TextStyle(
            fontSize: 15,
            color: Colors.grey,
          ),
        )
      ],
    );
  }
}
