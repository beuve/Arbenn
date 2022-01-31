import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  final String label;
  final bool isActive;
  final Color foregroundColor;
  final Color? backgroundColor;
  final Function()? onPressed;
  final double fontSize;

  const Tag(
      {Key? key,
      required this.label,
      required this.foregroundColor,
      this.backgroundColor,
      this.onPressed,
      this.fontSize = 18,
      this.isActive = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Container(
        margin: const EdgeInsets.only(bottom: 6, right: 6),
        padding: EdgeInsets.symmetric(
            horizontal: fontSize / 3, vertical: fontSize / 4),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(fontSize / 4)),
          border: backgroundColor == null
              ? Border.all(color: foregroundColor, width: fontSize / 9)
              : null,
        ),
        child: Text(
          "#" + label,
          style: TextStyle(color: foregroundColor, fontSize: fontSize),
        ),
      ),
      onPressed: onPressed,
    );
  }
}

Widget tags(
  List<String> tagList, {
  Color? backgroundColor,
  required Color foregroundColor,
  double fontSize = 18,
}) {
  return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.center,
      children: tagList
          .map((l) => Tag(
                label: l,
                foregroundColor: foregroundColor,
                backgroundColor: backgroundColor,
                isActive: false,
                fontSize: fontSize,
              ))
          .toList());
}
