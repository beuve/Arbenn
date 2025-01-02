import 'dart:math';

import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:arbenn/components/inputs.dart';
import 'package:arbenn/components/tags.dart';
import 'package:arbenn/data/tags_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void showSettings(
  BuildContext context, {
  required Function() updateTags,
  required Function() updateAddress,
  required Function() runSearch,
  required List<TagData> tags,
  required TextEditingController addressController,
  required DateRangePickingController dateRangeController,
}) {
  final height = MediaQuery.of(context).size.height;
  showModalBottomSheet(
      showDragHandle: true,
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: min(530 / height, 0.2),
          maxChildSize: min(530 / height, 0.8),
          minChildSize: min(530 / height, 0.2),
          builder: (context, scrollController) {
            return ListView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              controller: scrollController,
              children: [
                Text(
                  AppLocalizations.of(context)!.filter,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Row(children: [
                  Text(
                    AppLocalizations.of(context)!.tags,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Expanded(child: Text("")),
                  GestureDetector(
                    onTap: updateTags,
                    child: Text(
                      "Selection >",
                      style: TextStyle(color: Colors.blue[700]),
                    ),
                  ),
                ]),
                const SizedBox(height: 10),
                StaticTags(tags.map((t) => t.label).toList()),
                const SizedBox(height: 30),
                Text(
                  AppLocalizations.of(context)!.location,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                FormInput(
                  icon: AkarIcons.location,
                  label: AppLocalizations.of(context)!.address_search,
                  readOnly: true,
                  onTap: updateAddress,
                  controller: addressController,
                ),
                const SizedBox(height: 30),
                Text(
                  AppLocalizations.of(context)!.date,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                DateRangePicker(
                  context,
                  controller: dateRangeController,
                  startDate: DateTime(DateTime.now().year - 1),
                  stopDate: DateTime(DateTime.now().year + 2),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      runSearch();
                    },
                    child: Text(AppLocalizations.of(context)!.validate)),
                const SizedBox(height: 40),
              ],
            );
          },
        );
      });
}
