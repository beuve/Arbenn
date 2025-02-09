//   /$$$$$$  /$$$$$$$  /$$$$$$$  /$$$$$$$$ /$$   /$$ /$$   /$$
//  /$$__  $$| $$__  $$| $$__  $$| $$_____/| $$$ | $$| $$$ | $$
// | $$  \ $$| $$  \ $$| $$  \ $$| $$      | $$$$| $$| $$$$| $$
// | $$$$$$$$| $$$$$$$/| $$$$$$$ | $$$$$   | $$ $$ $$| $$ $$ $$
// | $$__  $$| $$__  $$| $$__  $$| $$__/   | $$  $$$$| $$  $$$$
// | $$  | $$| $$  \ $$| $$  \ $$| $$      | $$\  $$$| $$\  $$$
// | $$  | $$| $$  | $$| $$$$$$$/| $$$$$$$$| $$ \  $$| $$ \  $$
// |__/  |__/|__/  |__/|_______/ |________/|__/  \__/|__/  \__/

import 'package:arbenn/components/placeholders.dart';
import 'package:arbenn/data/event/event_data.dart';
import 'package:arbenn/data/user/user_data.dart';
import 'package:arbenn/pages/nav/nav.dart';
import 'package:arbenn/pages/signs/email_validation_page.dart';
import 'package:arbenn/pages/signs/sign_page.dart';
import 'package:arbenn/pages/forms/user_form/user_form.dart';
import 'package:arbenn/themes/themes.dart';
import 'package:arbenn/utils/errors/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:arbenn/data/user/authentication.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(systemNavigationBarColor: Colors.white),
  );
  Credentials? creds = await Credentials.hasStoredToken();
  await Credentials.deleteLocalToken();
  runApp(ChangeNotifierProvider(
    create: (context) => CredentialsNotifier(creds: creds),
    child: MaterialApp(
        title: 'ARBENN',
        theme: appTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        debugShowCheckedModeBanner: true,
        home: const CredentialsRoute()),
  ));
}

class Loading extends StatelessWidget {
  const Loading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.blue,
      body: Container(
        alignment: Alignment.center,
        color: Colors.blue,
        child: TickingBuilder(
          builder: (context, tick) => SvgPicture.asset(
            "assets/images/logo-white.svg",
            color: Color.lerp(Colors.blue[100], Colors.blue[400], tick),
            width: size.width * 0.5,
          ),
        ),
      ),
    );
  }
}

class Sign extends StatelessWidget {
  final Credentials? creds;

  const Sign({super.key, this.creds});

  Widget _route(BuildContext context) {
    if (creds == null) {
      return const SignPage();
    } else if (!creds!.verified) {
      return EmailValidationPage(userId: creds!.userId);
    }
    return UserFormPage(
        onFinish: (_) {
          Provider.of<CredentialsNotifier>(context, listen: false).hasData =
              true;
        },
        pop: false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ARBENN',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: appTheme,
      home: _route(context),
    );
  }
}

class App extends StatelessWidget {
  final Credentials creds;

  const App({super.key, required this.creds});

  Widget _route(
      BuildContext context, AsyncSnapshot<Result<UserData>> snapshot) {
    if (snapshot.hasData && snapshot.data!.isOk()) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => UserDataNotifier(snapshot.data!.unwrap())),
          ChangeNotifierProvider(
              create: (context) => AttendeEventsNotifier(
                  snapshot.data!.unwrap().userId,
                  creds: creds)),
        ],
        child: const Nav(),
      );
    } else if (snapshot.hasError ||
        (snapshot.hasData && snapshot.data!.isErr())) {
      return const Text("Error in App");
    }
    return const Loading();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Result<UserData>>(
      future: UserData.loadFromUserId(creds.userId, creds: creds),
      builder:
          (BuildContext context, AsyncSnapshot<Result<UserData>> snapshot) {
        return _route(context, snapshot);
      },
    );
  }
}

class CredentialsRoute extends StatelessWidget {
  const CredentialsRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CredentialsNotifier>(builder: (context, creds, _) {
      if (creds.value == null || !creds.value!.hasData) {
        return Sign(creds: creds.value);
      }
      return App(creds: creds.value!);
    });
  }
}
