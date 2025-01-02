import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:arbenn/pages/settings/components/_setting_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _newPasswordController = TextEditingController();

  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  Future<bool> onConfirm(BuildContext context) async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SettingPage(
        title: AppLocalizations.of(context)!.modify_pass,
        labels: [
          AppLocalizations.of(context)!.old_password,
          AppLocalizations.of(context)!.new_password,
          AppLocalizations.of(context)!.confirm_password,
        ],
        icons: const [AkarIcons.lock_on, AkarIcons.lock_on, AkarIcons.lock_on],
        controlers: [
          _passwordController,
          _newPasswordController,
          _confirmNewPasswordController
        ],
        onConfirm: () async => onConfirm(context));
  }
}
