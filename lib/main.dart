//   /$$$$$$  /$$$$$$$  /$$$$$$$  /$$$$$$$$ /$$   /$$ /$$   /$$
//  /$$__  $$| $$__  $$| $$__  $$| $$_____/| $$$ | $$| $$$ | $$
// | $$  \ $$| $$  \ $$| $$  \ $$| $$      | $$$$| $$| $$$$| $$
// | $$$$$$$$| $$$$$$$/| $$$$$$$ | $$$$$   | $$ $$ $$| $$ $$ $$
// | $$__  $$| $$__  $$| $$__  $$| $$__/   | $$  $$$$| $$  $$$$
// | $$  | $$| $$  \ $$| $$  \ $$| $$      | $$\  $$$| $$\  $$$
// | $$  | $$| $$  | $$| $$$$$$$/| $$$$$$$$| $$ \  $$| $$ \  $$
// |__/  |__/|__/  |__/|_______/ |________/|__/  \__/|__/  \__/

import 'package:arbenn/pages/nav.dart';
import 'package:arbenn/pages/sign_page.dart';
import 'package:arbenn/pages/user_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ARBENN',
      theme: ThemeData(
        primarySwatch: Colors.red,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum UserState { signedOut, signedIn, emailVerified, onboardingDone }

class _MyHomePageState extends State<MyHomePage> {
  late User? _user;

  UserState getUserState() {
    if (_user == null) {
      return UserState.signedOut;
    } else if (_user!.emailVerified) {
      return UserState.emailVerified;
    }
    return UserState.signedIn;
  }

  @override
  initState() {
    super.initState();
    FirebaseAuth.instance.signOut();
    _user = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() => _user = user);
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserState userState = getUserState();

    if (userState == UserState.signedOut) {
      return SignPage();
    } else if (userState == UserState.signedIn) {
      return const EmailValidationPage(nextPage: UserFormPage());
    } else if (userState == UserState.emailVerified) {
      return const UserFormPage();
    }
    return const Nav();
  }
}
