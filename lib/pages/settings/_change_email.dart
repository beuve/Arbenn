import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:arbenn/pages/settings/components/_setting_page.dart';
import 'package:arbenn/utils/errors/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({super.key});

  @override
  State<ChangeEmail> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _newEmailController = TextEditingController();

  Future<Result<()>> onConfirm(BuildContext context) async {
    return const Ok(());
  }

  @override
  Widget build(BuildContext context) {
    return SettingPage(
        title: AppLocalizations.of(context)!.modify_email,
        icons: const [AkarIcons.lock_on, AkarIcons.envelope],
        labels: [
          AppLocalizations.of(context)!.new_email,
          AppLocalizations.of(context)!.password,
        ],
        controlers: [_newEmailController, _passwordController],
        onConfirm: () async => onConfirm(context));
  }
}
