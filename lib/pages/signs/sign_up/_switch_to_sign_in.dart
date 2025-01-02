import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SwitchToSignInButton extends StatelessWidget {
  final Function() switchPage;

  const SwitchToSignInButton({
    super.key,
    required this.switchPage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: RichText(
        text: TextSpan(children: [
          const TextSpan(
            style: TextStyle(color: Colors.black),
            text: "Déjà un compte ? ",
          ),
          TextSpan(
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
              text: "Connecte-toi.",
              recognizer: TapGestureRecognizer()..onTap = switchPage)
        ]),
      ),
    );
  }
}
