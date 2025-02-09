import 'package:arbenn/components/snack_bar.dart';
import 'package:arbenn/pages/signs/components/_greetings.dart';
import 'package:arbenn/pages/signs/sign_up/_inputs.dart';
import 'package:arbenn/pages/signs/sign_up/_switch_to_sign_in.dart';
import 'package:arbenn/data/user/authentication.dart';
import 'package:arbenn/utils/errors/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  final Function() switchPage;
  const SignUpPage({super.key, required this.switchPage});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  late bool _isChecked;

  @override
  initState() {
    super.initState();
    _isChecked = false;
  }

  Future<void> _signUp() async {
    if (passController.text != confirmPassController.text) {
      showErrorSnackBar(
        context: context,
        text: 'Les mots de passe ne sont pas identiques.',
      );
      return;
    } else if (!_isChecked) {
      showErrorSnackBar(
        context: context,
        text:
            "Veuillez accepter les conditions d'utilisations et la politique de confidientialité.",
      );
      return;
    }
    Credentials.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passController.text,
    )
        .futureIter((creds) => creds.saveTokenLocally())
        .futureIter((creds) => creds.sendEmailVerification())
        .map((creds) => Provider.of<CredentialsNotifier>(context, listen: false)
            .value = creds);
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Container()),
                SvgPicture.asset(
                  "assets/images/arbenn.svg",
                  height: 50,
                ),
                Expanded(child: Container()),
                const SignGreetings(
                  title: "Crées toi un compte",
                  subTitle: "Heureux de te rencontrer !",
                ),
                const SizedBox(height: 30),
                SignUpInputs(
                  emailController: emailController,
                  passController: passController,
                  confirmPassController: confirmPassController,
                  isChecked: _isChecked,
                  onCheck: (value) => {
                    setState(
                      () => _isChecked = !_isChecked,
                    )
                  },
                ),
                Expanded(flex: 3, child: Container()),
                ElevatedButton(
                  onPressed: () async {
                    await _signUp();
                  },
                  child: const Text("VALIDER"),
                ),
                const SizedBox(height: 30),
                SwitchToSignInButton(
                  switchPage: widget.switchPage,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
