import 'package:arbenn/data/user/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class HomeTitle extends StatelessWidget {
  const HomeTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserDataNotifier>(context, listen: false).value;
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.hello,
            style: const TextStyle(fontSize: 35, fontWeight: FontWeight.w800),
          ),
          Text(
            "${user.firstName},",
            style: const TextStyle(fontSize: 35, fontWeight: FontWeight.w800),
          ),
          Text(
            AppLocalizations.of(context)!.home_what_to_do,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          )
        ],
      ),
    );
  }
}
