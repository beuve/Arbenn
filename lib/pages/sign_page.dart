import 'package:arbenn/components/overlay.dart';
import 'package:arbenn/components/page_transitions.dart';
import 'package:arbenn/components/snack_bar.dart';
import 'package:arbenn/utils/icons.dart';
import 'package:flutter/material.dart';
import '../components/up_expension.dart';
import '../components/inputs.dart';
import '../components/buttons.dart';
import '../utils/colors.dart';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class _ForgotPassword extends StatelessWidget {
  final Nuance color;
  final TextEditingController _emailController = TextEditingController();

  _ForgotPassword({Key? key, this.color = Palette.red}) : super(key: key);

  void onConfirm(BuildContext context) async {
    if (_emailController.text == "") {
      showSnackBar(
          context: context,
          text: "Entrez l'email lié à votre compte avant de valider.",
          color: color);
    } else {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FullPageOverlay(
      color: color,
      title: "Reinitialiser l'email",
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Icon(
              ArbennIcons.email,
              size: 150,
              color: color.darker,
            ),
            const SizedBox(height: 40),
            FormInput(
              label: "Email",
              color: color.dark,
              controller: _emailController,
            ),
            const SizedBox(height: 40),
            Button(
                color: color,
                label: "SEND EMAIL",
                onPressed: () => onConfirm(context))
          ],
        ),
      ),
    );
  }
}

class _Conditions extends StatelessWidget {
  final Nuance color;

  const _Conditions({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: RichText(
            text: TextSpan(style: TextStyle(color: color.darker), children: [
      const TextSpan(
        text: "J'accepte les ",
      ),
      TextSpan(
        style: TextStyle(color: color.flash),
        text: "conditions d'utilisation ",
      ),
      const TextSpan(
        text: "et la ",
      ),
      TextSpan(
        style: TextStyle(color: color.flash),
        text: "politique de confidentialité.",
      )
    ])));
  }
}

class _SignUp extends StatefulWidget {
  final double height;
  final Nuance color;
  const _SignUp({Key? key, required this.height, this.color = Palette.purple})
      : super(key: key);

  @override
  State<_SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<_SignUp> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  late bool _isChecked;

  @override
  initState() {
    super.initState();
    _isChecked = false;
  }

  Future<UserCredential?> _signUp() async {
    if (passController.text != confirmPassController.text) {
      showSnackBar(
          context: context,
          text: 'Les mots de passe ne sont pas identiques.',
          color: widget.color);
      return null;
    } else if (!_isChecked) {
      showSnackBar(
          context: context,
          text:
              "Veuillez accepter les conditions d'utilisations et la politique de confidientialité.",
          color: widget.color);
      return null;
    }
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passController.text);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(
            context: context,
            text: 'Le mot de passe choisit est trop faible.',
            color: widget.color);
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(
            context: context,
            text: 'Un compte existant utilise déjà cet email.',
            color: widget.color);
      } else if (e.code == "network-request-failed") {
        showSnackBar(
            context: context,
            text: "La connexion internet est trop faible.",
            color: widget.color);
      } else {
        showSnackBar(
            context: context,
            text: "Une erreur inconnue est survenue.",
            color: widget.color);
        print(e);
      }
      return null;
    } catch (e) {
      showSnackBar(
          context: context,
          text: "Une erreur inconnue est survenue.",
          color: widget.color);
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      height: widget.height,
      child: Column(
        children: [
          FormInput(
            label: "email",
            controller: emailController,
            color: widget.color.darker,
            autoFocus: true,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: widget.height * 0.05),
          FormInput(
            label: "mot de passe",
            color: widget.color.darker,
            controller: passController,
          ),
          SizedBox(height: widget.height * 0.05),
          FormInput(
            label: "confirmer mot de passe",
            color: widget.color.darker,
            controller: confirmPassController,
          ),
          SizedBox(height: widget.height * 0.05),
          Row(
            children: [
              Checkbox(
                activeColor: widget.color.darker,
                value: _isChecked,
                onChanged: (value) =>
                    {setState(() => _isChecked = !_isChecked)},
              ),
              _Conditions(color: widget.color),
            ],
          ),
          SizedBox(height: widget.height * 0.05),
          Button(
            color: Palette.purple,
            label: "VALIDER",
            onPressed: () async {
              UserCredential? userCredential = await _signUp();
              if (userCredential != null && userCredential.user != null) {
                userCredential.user!.sendEmailVerification();
              }
            },
          )
        ],
      ),
    );
  }
}

class _SignIn extends StatelessWidget {
  final Nuance color;
  final double height;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  _SignIn({Key? key, required this.height, this.color = Palette.red})
      : super(key: key);

  Future<UserCredential?> _signIn(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passController.text);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackBar(
            context: context,
            text: 'Aucun utilisateur existant avec cet email.',
            color: color);
      } else if (e.code == 'wrong-password') {
        showSnackBar(
            context: context,
            text: "Le mot de passe n'est pas celui associé a cet email.",
            color: color);
      } else if (e.code == "network-request-failed") {
        showSnackBar(
            context: context,
            text: "La connexion internet est trop faible.",
            color: color);
      } else {
        showSnackBar(
            context: context,
            text: "Une erreur inconnue est survenue.",
            color: color);
        print(e);
      }
      return null;
    } catch (e) {
      showSnackBar(
          context: context,
          text: "Une erreur inconnue est survenue.",
          color: color);
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      height: height,
      child: Column(
        children: [
          SizedBox(height: height * 0.07),
          FormInput(
            label: "email",
            color: color.darker,
            controller: emailController,
            autoFocus: true,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: height * 0.08),
          FormInput(
              label: "mot de passe",
              color: color.darker,
              controller: passController),
          Container(
              margin: const EdgeInsets.only(top: 5, right: 10),
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () =>
                      Navigator.of(context).push(slideIn(_ForgotPassword())),
                  child: Text(
                    "Mot de pass oublié ?",
                    style: TextStyle(color: color.flash),
                  ))),
          SizedBox(height: height * 0.12),
          Button(
            color: Palette.red,
            label: "VALIDER",
            onPressed: () async {
              UserCredential? _ = await _signIn(context);
            },
          )
        ],
      ),
    );
  }
}

class SignPage extends StatelessWidget {
  late final GlobalKey<UpTileState> signInTile;
  late final GlobalKey<UpTileState> signUpTile;

  SignPage({Key? key}) : super(key: key) {
    signInTile = GlobalKey();
    signUpTile = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxHeight > 800) {}
      return Container(
        color: Palette.red.lighter,
        padding: const EdgeInsets.only(bottom: 20),
        //bottom: false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              tileUp(
                color: Palette.purple,
                key: signInTile,
                child: _SignUp(height: 0.7 * constraints.maxHeight),
                concurrentKeys: [signUpTile],
                label: "INSCRIPTION",
              ),
              tileUp(
                color: Palette.red,
                key: signUpTile,
                background: Palette.purple.lighter,
                child: _SignIn(height: 0.7 * constraints.maxHeight),
                concurrentKeys: [signInTile],
                label: "CONNEXION",
              ),
            ],
          ),
        ),
      );
    });
  }
}

class EmailValidationPage extends StatefulWidget {
  final Function() onFinish;
  final Nuance color;

  const EmailValidationPage(
      {Key? key, required this.onFinish, this.color = Palette.red})
      : super(key: key);

  @override
  State<EmailValidationPage> createState() => _EmailValidationPageState();
}

class _EmailValidationPageState extends State<EmailValidationPage> {
  late bool _emailSent;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _emailSent = false;
    _timer = Timer.periodic(const Duration(seconds: 3), _checkUserEmail);
  }

  void _checkUserEmail(Timer _) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      if (user.emailVerified) {
        _timer.cancel();
        widget.onFinish();
      }
    }
  }

  void sendAgain() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      user.sendEmailVerification();
      setState(() => _emailSent = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        color: widget.color.darker,
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                ArbennIcons.email,
                size: 150,
                color: widget.color.lighter,
              ),
              Text(
                "Verifiez vos emails, nous vous en avons envoyé un pour activer votre compte.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: widget.color.lighter,
                  fontSize: 15,
                  decoration: null,
                ),
              ),
              const SizedBox(height: 80),
              if (!_emailSent)
                Button(
                  color: widget.color,
                  theme: ColorTheme.dark,
                  label: "Envoyer à nouveau",
                  onPressed: () => sendAgain(),
                )
            ],
          ),
        ),
      ),
    );
  }
}
