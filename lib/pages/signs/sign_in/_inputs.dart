import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:arbenn/components/inputs.dart';
import 'package:flutter/material.dart';

class SignInInputs extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passController;

  const SignInInputs({
    super.key,
    required this.emailController,
    required this.passController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormInput(
          icon: AkarIcons.envelope,
          label: "email",
          controller: emailController,
          autoFocus: true,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),
        FormInput(
          icon: AkarIcons.lock_on,
          label: "mot de passe",
          hideButton: true,
          controller: passController,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: const Text(
              "Mot de pass oublié ?",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
