import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:arbenn/components/buttons.dart';
import 'package:arbenn/components/inputs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchArea extends StatelessWidget {
  final TextEditingController searchText;
  final Function() showSettings;

  const SearchArea({
    super.key,
    required this.searchText,
    required this.showSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        AppLocalizations.of(context)!.search,
        style: const TextStyle(fontSize: 35, fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 15),
      Row(
        children: [
          Expanded(
            child: SearchInput(
              label: AppLocalizations.of(context)!.event_search,
              controller: searchText,
            ),
          ),
          const SizedBox(width: 15),
          FilledSquareButton(
            icon: AkarIcons.filter,
            onTap: showSettings,
          ),
        ],
      ),
      const SizedBox(height: 15),
    ]);
  }
}
