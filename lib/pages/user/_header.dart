import 'package:arbenn/data/user/user_data.dart';
import 'package:flutter/material.dart';

class ProfilePageHeader extends StatelessWidget {
  final UserData user;

  const ProfilePageHeader({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    double paddingTop = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      height: 250 + paddingTop,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.black12),
        image: user.pictureUrl == null
            ? null
            : DecorationImage(
                image: NetworkImage(user.pictureUrl!),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
