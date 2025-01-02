import 'package:arbenn/pages/signs/sign_in/sign_in_page.dart';
import 'package:arbenn/pages/signs/sign_up/sign_up_page.dart';
import 'package:flutter/material.dart';

enum Page { none, signIN, signUP }

class SignPage extends StatefulWidget {
  const SignPage({super.key});

  @override
  State<SignPage> createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  Page _page = Page.signIN;

  switchPage() {
    if (_page == Page.signIN) {
      setState(() => _page = Page.signUP);
    } else if (_page == Page.signUP) {
      setState(() => _page = Page.signIN);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_page == Page.signIN) {
      return SignInPage(switchPage: switchPage);
    }
    return SignUpPage(switchPage: switchPage);
  }
}
