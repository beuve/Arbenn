import 'package:arbenn/components/inputs.dart';
import 'package:flutter/material.dart';
import 'package:arbenn/components/overlay.dart';
import 'package:arbenn/components/buttons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingPage extends StatelessWidget {
  final String title;
  final List<TextEditingController> controlers;
  final List<String> labels;
  final List<IconData> icons;
  final Future<bool> Function() onConfirm;

  const SettingPage(
      {super.key,
      required this.title,
      required this.labels,
      required this.icons,
      required this.controlers,
      required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    assert(controlers.length == labels.length);
    List<Widget> inputs = [];
    for (var i = 0; i < controlers.length; i++) {
      inputs.add(
        FormInput(
          label: labels[i],
          icon: icons[i],
          controller: controlers[i],
        ),
      );
      inputs.add(const SizedBox(height: 20));
    }
    return FullPageOverlay(
      title: title,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Expanded(child: Container()),
          ...inputs,
          Expanded(flex: 2, child: Container()),
          FutureButton(
              label: AppLocalizations.of(context)!.validate,
              onPressed: onConfirm)
        ]),
      ),
    );
  }
}
