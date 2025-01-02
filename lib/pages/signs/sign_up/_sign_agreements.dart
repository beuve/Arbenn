import 'package:flutter/material.dart';

class SignAgreements extends StatelessWidget {
  const SignAgreements({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black),
          children: [
            const TextSpan(
              text: "J'accepte les ",
            ),
            TextSpan(
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
              text: "conditions d'utilisation ",
            ),
            const TextSpan(
              text: "et la ",
            ),
            TextSpan(
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
              text: "politique de confidentialité.",
            )
          ],
        ),
      ),
    );
  }
}
