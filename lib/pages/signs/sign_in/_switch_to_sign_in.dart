import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SwitchToSignUpButton extends StatelessWidget {
  final Function() switchPage;

  const SwitchToSignUpButton({
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
            text: "Première fois ici ? ",
          ),
          TextSpan(
              style: const TextStyle(color: Colors.blue),
              text: "Crées un compte.",
              recognizer: TapGestureRecognizer()..onTap = switchPage)
        ]),
      ),
    );
  }
}
