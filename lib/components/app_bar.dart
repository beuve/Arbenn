import 'package:arbenn/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:arbenn/utils/colors.dart';

class _AppBarContent extends StatelessWidget {
  final Nuance color;

  const _AppBarContent({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.main,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20),
            alignment: Alignment.centerLeft,
            child: Text(
              "ARBENN",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: color.darker),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 30),
            alignment: Alignment.centerRight,
            child: Icon(
              ArbennIcons.bell,
              size: 25,
              color: color.lighter,
            ),
          )
        ],
      ),
    );
  }
}

PreferredSizeWidget appBar(BuildContext context, Nuance color) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(40),
    child: _AppBarContent(color: color),
  );
}
