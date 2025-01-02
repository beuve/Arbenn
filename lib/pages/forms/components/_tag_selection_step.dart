import 'package:arbenn/components/inputs.dart';
import 'package:arbenn/components/tags.dart';
import 'package:arbenn/data/tags_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FormsTagSelectionStep extends StatelessWidget {
  final TagSearch tagSearch;
  final Function(String) onSearch;

  const FormsTagSelectionStep({
    super.key,
    required this.tagSearch,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20, top: 20),
            child: Text(
              AppLocalizations.of(context)!.tags_selection,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              bottom: 20,
              left: 20,
              right: 20,
              top: 10,
            ),
            child: SearchInput(
              label: AppLocalizations.of(context)!.tags_search,
              onChanged: onSearch,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Tags(tags: tagSearch.tags),
          ),
        ],
      ),
    );
  }
}
