import 'package:flutter/material.dart';
import '../components/up_expension.dart';
import '../components/inputs.dart';
import '../components/buttons.dart';
import '../utils/colors.dart';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class _Conditions extends StatelessWidget {
  const _Conditions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: RichText(
            text: TextSpan(
                style: TextStyle(color: Palette.purple.darker),
                children: [
          const TextSpan(
            text: "J'accepte les ",
          ),
          TextSpan(
            style: TextStyle(color: Palette.purple.flash),
            text: "conditions d'utilisation ",
          ),
          const TextSpan(
            text: "et la ",
          ),
          TextSpan(
            style: TextStyle(color: Palette.purple.flash),
            text: "politique de confidentialité.",
          )
        ])));
  }
}

class _SignUp extends StatefulWidget {
  final double height;
  const _SignUp({Key? key, required this.height}) : super(key: key);

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
      return null;
    } else if (!_isChecked) {
      return null;
    }
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passController.text);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return null;
    } catch (e) {
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
            color: Palette.purple.darker,
            autoFocus: true,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: widget.height * 0.05),
          FormInput(
            label: "mot de passe",
            color: Palette.purple.darker,
            controller: passController,
          ),
          SizedBox(height: widget.height * 0.05),
          FormInput(
            label: "confirmer mot de passe",
            color: Palette.purple.darker,
            controller: confirmPassController,
          ),
          SizedBox(height: widget.height * 0.05),
          Row(
            children: [
              Checkbox(
                activeColor: Palette.purple.darker,
                value: _isChecked,
                onChanged: (value) =>
                    {setState(() => _isChecked = !_isChecked)},
              ),
              const _Conditions(),
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
  final double height;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  _SignIn({Key? key, required this.height}) : super(key: key);

  Future<UserCredential?> _signIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passController.text);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
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
            color: Palette.red.darker,
            controller: emailController,
            autoFocus: true,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: height * 0.08),
          FormInput(
              label: "mot de passe",
              color: Palette.red.darker,
              controller: passController),
          Container(
              margin: const EdgeInsets.only(top: 5, right: 10),
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () => {},
                  child: Text(
                    "Mot de pass oublié ?",
                    style: TextStyle(color: Palette.red.flash),
                  ))),
          SizedBox(height: height * 0.12),
          Button(
            color: Palette.red,
            label: "VALIDER",
            onPressed: () async {
              UserCredential? _ = await _signIn();
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
  final Widget nextPage;
  final Nuance color;

  const EmailValidationPage(
      {Key? key, required this.nextPage, this.color = Palette.red})
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => widget.nextPage),
        );
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
                Icons.email,
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
