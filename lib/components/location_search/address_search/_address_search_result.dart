import 'package:arbenn/data/locations_data.dart';
import 'package:flutter/material.dart' hide Autocomplete;
import 'package:akar_icons_flutter/akar_icons_flutter.dart';

class AddressSearchResult extends StatelessWidget {
  final Address infos;
  final Function()? onTap;

  const AddressSearchResult({
    super.key,
    required this.infos,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: RichText(
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
          text: TextSpan(
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                baseline: TextBaseline.ideographic,
                child: Icon(
                  AkarIcons.location,
                  size: 14,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              TextSpan(
                text: " ${infos.toString()}",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
