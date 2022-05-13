import 'package:arbenn/components/inputs.dart';
import 'package:arbenn/components/page_transitions.dart';
import 'package:arbenn/components/snack_bar.dart';
import 'package:arbenn/pages/user_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:arbenn/utils/colors.dart';
import 'package:arbenn/components/overlay.dart';
import 'package:arbenn/components/buttons.dart';
import 'package:arbenn/data/user_data.dart';
import 'dart:developer' as developer;

class UserSettings extends StatelessWidget {
  final UserData user;
  final Nuance color;
  final Function(UserData) onEditUser;

  const UserSettings(
      {Key? key,
      required this.user,
      required this.onEditUser,
      this.color = Palette.blue})
      : super(key: key);

  Widget _buildBody(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.uid == user.userId) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const SizedBox(height: 50),
            SettingButton(
              color: color,
              label: "Modifier mon profile",
              onPressed: () => Navigator.of(context).push(
                  slideIn(UserFormPage(user: user, onFinish: onEditUser))),
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

class ChangeEmail extends StatefulWidget {
  final Nuance color;

  const ChangeEmail({Key? key, this.color = Palette.blue}) : super(key: key);

  @override
  State<ChangeEmail> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _newEmailController = TextEditingController();

  Future<bool> onConfirm(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (_passwordController.text == "") {
      showSnackBar(
          context: context,
          text: "Veillez entrer le mot de passe actuel.",
          color: widget.color);
      return true;
    } else if (_newEmailController.text == "") {
      showSnackBar(
          context: context,
          text: "Veillez entrer le nouvel email.",
          color: widget.color);
      return true;
    } else if (user != null) {
      if (_newEmailController.text == user.email) {
        showSnackBar(
            context: context,
            text: "Le nouvel email est identique a l'ancien.",
            color: widget.color);
        return true;
      } else {
        try {
          AuthCredential credential = EmailAuthProvider.credential(
              email: user.email!, password: _passwordController.text);
          await user.reauthenticateWithCredential(credential);
          await user.updateEmail(_newEmailController.text);
          await user.reload();
          if (!mounted) return true;
          Navigator.pop(context);
          return false;
        } on FirebaseAuthException catch (e) {
          if (e.code == "email-already-in-use") {
            showSnackBar(
                context: context,
                text: "Cet email est déjà associé a un autre compte.",
                color: widget.color);
            return true;
          } else if (e.code == "wrong-password") {
            showSnackBar(
                context: context,
                text: "Le mot de passe est incorrect.",
                color: widget.color);
            return true;
          } else if (e.code == "network-request-failed") {
            showSnackBar(
                context: context,
                text: "La connexion internet est trop faible.",
                color: widget.color);
            return true;
          } else {
            showSnackBar(
                context: context,
                text: "Une erreur inconnue est survenue.",
                color: widget.color);
            developer.log(
              "Unknown network error",
              name: "data/event_search Search.create",
              error: e,
            );
            return true;
          }
        } catch (e) {
          showSnackBar(
              context: context,
              text: "Une erreur inconnue est survenue.",
              color: widget.color);
          developer.log(
            "Internal error",
            name: "data/event_search Search.create",
            error: e,
          );
          return true;
        }
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
            color: widget.color.dark,
            controller: _passwordController,
          ),
          const SizedBox(height: 20),
          FormInput(
            label: "New email",
            color: widget.color.dark,
            controller: _newEmailController,
          ),
          const SizedBox(height: 40),
          FutureButton(
              color: widget.color,
              label: "VALIDER",
              onPressed: () async => onConfirm(context))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FullPageOverlay(
        color: widget.color, title: "Parametres", body: _buildBody(context));
  }
}

class ChangePassword extends StatefulWidget {
  final Nuance color;

  const ChangePassword({Key? key, this.color = Palette.blue}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _newPasswordController = TextEditingController();

  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  Future<bool> onConfirm(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (_passwordController.text == "") {
      showSnackBar(
          context: context,
          text: "Veillez entrer le mot de passe actuel.",
          color: widget.color);
      return true;
    } else if (user != null) {
      AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!, password: _passwordController.text);
      if (_newPasswordController.text == "") {
        showSnackBar(
            context: context,
            text: "Veillez entrer un nouveau mot de passe.",
            color: widget.color);
        return true;
      } else if (_confirmNewPasswordController.text !=
          _newPasswordController.text) {
        showSnackBar(
            context: context,
            text: "Les mots de passes ne correspondent pas.",
            color: widget.color);
        return true;
      } else {
        try {
          await user.reauthenticateWithCredential(credential);
          await user.updatePassword(_newPasswordController.text);
          if (!mounted) return true;
          Navigator.pop(context);
          return false;
        } on FirebaseAuthException catch (e) {
          if (e.code == "wrong-password") {
            showSnackBar(
                context: context,
                text: "Le mot de passe est incorrect.",
                color: widget.color);
            return true;
          } else if (e.code == "weak-password") {
            showSnackBar(
                context: context,
                text: "Le nouveau mot de passe est trop faible.",
                color: widget.color);
            return true;
          } else if (e.code == "network-request-failed") {
            showSnackBar(
                context: context,
                text: "La connexion internet est trop faible.",
                color: widget.color);
            return true;
          } else {
            showSnackBar(
                context: context,
                text: "Une erreur inconnue est survenue.",
                color: widget.color);
            developer.log(
              "Unknown network error",
              name: "data/event_search Search.create",
              error: e,
            );
            return true;
          }
        } catch (e) {
          showSnackBar(
              context: context,
              text: "Une erreur inconnue est survenue.",
              color: widget.color);
          developer.log(
            "Internal error",
            name: "data/event_search Search.create",
            error: e,
          );
          return true;
        }
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
              color: widget.color.darker,
              controller: _passwordController),
          const SizedBox(height: 20),
          FormInput(
            label: "New pasword",
            color: widget.color.darker,
            controller: _newPasswordController,
          ),
          const SizedBox(height: 20),
          FormInput(
            label: "Confirm new password",
            color: widget.color.darker,
            controller: _confirmNewPasswordController,
          ),
          const SizedBox(height: 40),
          FutureButton(
              color: widget.color,
              label: "VALIDER",
              onPressed: () async => onConfirm(context))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FullPageOverlay(
        color: widget.color, title: "Settings", body: _buildBody(context));
  }
}
