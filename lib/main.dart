//   /$$$$$$  /$$$$$$$  /$$$$$$$  /$$$$$$$$ /$$   /$$ /$$   /$$
//  /$$__  $$| $$__  $$| $$__  $$| $$_____/| $$$ | $$| $$$ | $$
// | $$  \ $$| $$  \ $$| $$  \ $$| $$      | $$$$| $$| $$$$| $$
// | $$$$$$$$| $$$$$$$/| $$$$$$$ | $$$$$   | $$ $$ $$| $$ $$ $$
// | $$__  $$| $$__  $$| $$__  $$| $$__/   | $$  $$$$| $$  $$$$
// | $$  | $$| $$  \ $$| $$  \ $$| $$      | $$\  $$$| $$\  $$$
// | $$  | $$| $$  | $$| $$$$$$$/| $$$$$$$$| $$ \  $$| $$ \  $$
// |__/  |__/|__/  |__/|_______/ |________/|__/  \__/|__/  \__/

import 'package:arbenn/data/user_data.dart';
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

class _MyHomePageState extends State<MyHomePage> {
  late User? _user;

  @override
  initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() => _user = user);
    });
  }

  Future<UserData?> getUserData() async {
    if (_user == null) {
      return null;
    }
    return UserData.loadFromUserId(_user!.uid);
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return SignPage();
    } else if (_user!.emailVerified == false) {
      return const EmailValidationPage(nextPage: UserFormPage());
    }
    return FutureBuilder<UserData?>(
      future: getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null) {
            return const UserFormPage();
          }
          return Nav(currentUser: snapshot.data!);
        } else if (snapshot.hasError) {
          return const Text("error");
        } else {
          return const Text("Waiting main");
        }
      },
    );
  }
}
