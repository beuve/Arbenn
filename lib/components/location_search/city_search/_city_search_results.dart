import 'package:arbenn/data/locations_data.dart';
import 'package:flutter/material.dart' hide Autocomplete;

class CitySearchResult extends StatelessWidget {
  final City infos;
  final Function()? onTap;

  const CitySearchResult({
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
          padding: const EdgeInsets.all(15),
          child: Text(
            infos.toString(),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ));
  }
}
