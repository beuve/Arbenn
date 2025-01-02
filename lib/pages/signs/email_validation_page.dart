import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:arbenn/data/user/authentication.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';

class EmailValidationPage extends StatefulWidget {
  final int userId;

  const EmailValidationPage({
    super.key,
    required this.userId,
  });

  @override
  State<EmailValidationPage> createState() => _EmailValidationPageState();
}

class _EmailValidationPageState extends State<EmailValidationPage> {
  late bool _emailSent;

  @override
  void initState() {
    super.initState();
    _emailSent = false;
  }

  void _checkUserEmail(Timer _) async {
    await Provider.of<CredentialsNotifier>(context, listen: false)
        .value!
        .emailIsVerified()
        .then(
      (emailVerified) {
        if (emailVerified) {
          if (context.mounted) {
            final oldCreds =
                Provider.of<CredentialsNotifier>(context, listen: false).value!;
            Provider.of<CredentialsNotifier>(context, listen: false).value =
                Credentials(
                    userId: oldCreds.userId,
                    token: oldCreds.token,
                    verified: emailVerified);
          }
        }
      },
    );
  }

  void sendAgain() {
    Credentials? user =
        Provider.of<CredentialsNotifier>(context, listen: false).value;
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
        color: Colors.blue,
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                AkarIcons.envelope,
                size: 150,
                color: Colors.white,
              ),
              const Text(
                "Verifiez vos emails, nous vous en avons envoyé un pour activer votre compte.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  decoration: null,
                ),
              ),
              const SizedBox(height: 80),
              if (!_emailSent)
                ElevatedButton(
                  onPressed: () => sendAgain(),
                  child: const Text("Envoyer à nouveau"),
                )
            ],
          ),
        ),
      ),
    );
  }
}
