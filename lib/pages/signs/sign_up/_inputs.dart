import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:arbenn/components/inputs.dart';
import 'package:arbenn/pages/signs/sign_up/_sign_agreements.dart';
import 'package:flutter/material.dart';

class SignUpInputs extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passController;
  final TextEditingController confirmPassController;
  final bool isChecked;
  final Function(bool?) onCheck;

  const SignUpInputs({
    super.key,
    required this.emailController,
    required this.passController,
    required this.confirmPassController,
    required this.isChecked,
    required this.onCheck,
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
        const SizedBox(height: 20),
        FormInput(
          icon: AkarIcons.lock_on,
          label: "confirmer mot de passe",
          hideButton: true,
          controller: confirmPassController,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Checkbox(
              activeColor: Colors.blue,
              value: isChecked,
              onChanged: onCheck,
            ),
            const SignAgreements(),
          ],
        ),
      ],
    );
  }
}
