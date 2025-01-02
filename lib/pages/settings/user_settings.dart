import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:arbenn/pages/settings/_change_email.dart';
import 'package:arbenn/pages/settings/_change_password.dart';
import 'package:arbenn/utils/page_transitions.dart';
import 'package:arbenn/pages/forms/user_form/user_form.dart';
import 'package:flutter/material.dart';
import 'package:arbenn/components/overlay.dart';
import 'package:arbenn/components/buttons.dart';
import 'package:arbenn/data/user/user_data.dart';
import 'package:provider/provider.dart';
import 'package:arbenn/data/user/authentication.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserSettings extends StatelessWidget {
  final UserData user;
  final Function(UserData) onEditUser;

  const UserSettings({super.key, required this.user, required this.onEditUser});

  Widget _sep() {
    return Container(
      height: 1,
      decoration: BoxDecoration(color: Colors.grey[200]),
    );
  }

  Widget _buildBody(BuildContext context) {
    final int currentUserId =
        context.select((CredentialsNotifier creds) => user.userId)!;
    if (currentUserId == user.userId) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            SettingButton(
              label: AppLocalizations.of(context)!.modify_profile,
              icon: AkarIcons.person,
              onPressed: () => Navigator.of(context).push(
                  slideIn(UserFormPage(user: user, onFinish: onEditUser))),
            ),
            _sep(),
            SettingButton(
              label: AppLocalizations.of(context)!.modify_email,
              icon: AkarIcons.envelope,
              onPressed: () =>
                  Navigator.of(context).push(slideIn(const ChangeEmail())),
            ),
            _sep(),
            SettingButton(
              label: AppLocalizations.of(context)!.modify_pass,
              icon: AkarIcons.lock_on,
              onPressed: () =>
                  Navigator.of(context).push(slideIn(const ChangePassword())),
            ),
            _sep(),
            SettingButton(
              label: AppLocalizations.of(context)!.notif_preferences,
              icon: AkarIcons.bell,
              onPressed: () {},
            ),
            _sep(),
            SettingButton(
              label: AppLocalizations.of(context)!.logout,
              icon: AkarIcons.sign_out,
              color: Colors.grey,
              onPressed: () async {
                await Credentials.deleteLocalToken().then((_) {
                  Navigator.of(context).pop();
                  Provider.of<CredentialsNotifier>(context, listen: false)
                      .value = null;
                });
              },
            ),
            _sep(),
            SettingButton(
              label: AppLocalizations.of(context)!.delete_account,
              icon: AkarIcons.trash_can,
              color: Colors.grey,
              onPressed: () {},
            ),
          ],
        ),
      );
    } else {
      return const Text("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FullPageOverlay(
      title: AppLocalizations.of(context)!.parameters,
      body: _buildBody(context),
    );
  }
}
