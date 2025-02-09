import 'package:arbenn/pages/signs/components/_greetings.dart';
import 'package:arbenn/pages/signs/sign_in/_inputs.dart';
import 'package:arbenn/pages/signs/sign_in/_switch_to_sign_in.dart';
import 'package:arbenn/data/user/authentication.dart';
import 'package:arbenn/utils/errors/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  final Function() switchPage;
  const SignInPage({super.key, required this.switchPage});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  Future<void> _signIn(BuildContext context) async {
    await Credentials.signInWithEmailAndPassword(
            email: emailController.text, password: passController.text)
        .futureIter((creds) => creds.saveTokenLocally())
        .futureIter((creds) async {
      if (context.mounted) {
        Provider.of<CredentialsNotifier>(context, listen: false).value = creds;
      }
    }).showError(context);
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
                  title: "Heureux de te retrouver !",
                  subTitle: "Connecte-toi à ton compte",
                ),
                const SizedBox(height: 40),
                SignInInputs(
                  emailController: emailController,
                  passController: passController,
                ),
                Expanded(flex: 3, child: Container()),
                ElevatedButton(
                  child: const Text("VALIDER"),
                  onPressed: () => _signIn(context),
                ),
                const SizedBox(height: 30),
                SwitchToSignUpButton(switchPage: widget.switchPage),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
