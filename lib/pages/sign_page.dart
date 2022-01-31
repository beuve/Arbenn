import 'package:flutter/material.dart';
import '../components/up_expension.dart';
import '../components/inputs.dart';
import '../components/buttons.dart';
import '../utils/colors.dart';
import 'user_form.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        height: widget.height,
        child: Column(children: [
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserFormPage()),
                );
              })
        ]));
  }
}

class _SignIn extends StatelessWidget {
  final double height;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  _SignIn({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        height: height,
        child: Column(children: [
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
          Button(color: Palette.red, label: "VALIDER", onPressed: () {})
        ]));
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
