import 'package:arbenn/pages/user_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../components/overlay.dart';
import '../components/buttons.dart';
import '../data/user_data.dart';

class UserSettings extends StatelessWidget {
  final UserData user;
  final Nuance color;

  const UserSettings({Key? key, required this.user, this.color = Palette.blue})
      : super(key: key);

  Widget _buildBody(BuildContext context) {
    User? _user = FirebaseAuth.instance.currentUser;
    if (_user != null && _user.uid == user.userId) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const SizedBox(height: 50),
            SettingButton(
              color: color,
              label: "Modifier mon profile",
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserFormPage(user: user),
                  ),
                ),
              },
            ),
            const SizedBox(height: 15),
            SettingButton(
              color: color,
              label: "Modifier mon email",
              onPressed: () => {},
            ),
            const SizedBox(height: 15),
            SettingButton(
              color: color,
              label: "Modifier mon mot de passe",
              onPressed: () => {},
            ),
            const SizedBox(height: 15),
            SettingButton(
              color: color,
              label: "Me deconecter",
              onPressed: () {
                Navigator.pop(context);
                FirebaseAuth.instance.signOut();
              },
            )
          ],
        ),
      );
    } else {
      return const Text("Wrong user");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FullPageOverlay(
        color: color, title: "Settings", body: _buildBody(context));
  }
}
