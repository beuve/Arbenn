import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../components/overlay.dart';
import '../components/buttons.dart';

class UserSettings extends StatelessWidget {
  final String userId;
  final Nuance color;

  const UserSettings(
      {Key? key, required this.userId, this.color = Palette.blue})
      : super(key: key);

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          const SizedBox(height: 50),
          SettingButton(
            color: color,
            label: "Modifier mon profile",
            onPressed: () => {},
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
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FullPageOverlay(color: color, title: "Settings", body: _buildBody());
  }
}
