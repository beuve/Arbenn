import 'package:arbenn/components/inputs.dart';
import 'package:arbenn/components/page_transitions.dart';
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
              onPressed: () => Navigator.of(context).push(slideIn(UserFormPage(
                  user: user, onFinish: (_) => Navigator.of(context).pop()))),
            ),
            const SizedBox(height: 15),
            SettingButton(
              color: color,
              label: "Modifier mon email",
              onPressed: () => Navigator.of(context)
                  .push(slideIn(ChangeEmail(color: color))),
            ),
            const SizedBox(height: 15),
            SettingButton(
              color: color,
              label: "Modifier mon mot de passe",
              onPressed: () => Navigator.of(context)
                  .push(slideIn(ChangePassword(color: color))),
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

class ChangeEmail extends StatelessWidget {
  final Nuance color;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newEmailController = TextEditingController();

  ChangeEmail({Key? key, this.color = Palette.blue}) : super(key: key);

  void onConfirm(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!, password: _passwordController.text);
      await user.reauthenticateWithCredential(credential);
      await user.updateEmail(_newEmailController.text);
      Navigator.pop(context);
    } else {
      throw Exception("User is null");
    }
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 40),
          FormInput(
            label: "Password",
            color: color.dark,
            controller: _passwordController,
          ),
          const SizedBox(height: 20),
          FormInput(
            label: "New email",
            color: color.dark,
            controller: _newEmailController,
          ),
          const SizedBox(height: 40),
          Button(
              color: color,
              label: "VALIDER",
              onPressed: () => onConfirm(context))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FullPageOverlay(
        color: color, title: "Settings", body: _buildBody(context));
  }
}

class ChangePassword extends StatelessWidget {
  final Nuance color;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  ChangePassword({Key? key, this.color = Palette.blue}) : super(key: key);

  void onConfirm(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print(user.email);
      AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!, password: _passwordController.text);
      await user.reauthenticateWithCredential(credential);
      if (_confirmNewPasswordController.text == _newPasswordController.text) {
        await user.updatePassword(_newPasswordController.text);
        Navigator.pop(context);
      } else {
        print("New password is not the same");
      }
    } else {
      throw Exception("User is null");
    }
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 40),
          FormInput(
              label: "Password",
              color: color.darker,
              controller: _passwordController),
          const SizedBox(height: 20),
          FormInput(
            label: "New pasword",
            color: color.darker,
            controller: _newPasswordController,
          ),
          const SizedBox(height: 20),
          FormInput(
            label: "Confirm new password",
            color: color.darker,
            controller: _confirmNewPasswordController,
          ),
          const SizedBox(height: 40),
          Button(
              color: color,
              label: "VALIDER",
              onPressed: () => onConfirm(context))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FullPageOverlay(
        color: color, title: "Settings", body: _buildBody(context));
  }
}
