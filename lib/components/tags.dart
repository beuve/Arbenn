import 'package:arbenn/utils/colors.dart';
import 'package:flutter/material.dart';

class TagInfos {
  final String label;
  bool isActive;
  Function()? onTap;

  TagInfos({required this.label, this.isActive = false, this.onTap});
}

class Tag extends StatelessWidget {
  final String label;
  final bool isActive;
  final Nuance color;
  final Function()? onPressed;
  final double fontSize;

  const Tag(
      {Key? key,
      required this.label,
      required this.color,
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
          horizontal: fontSize / 3 + (isActive ? fontSize / 9 : 0),
          vertical: fontSize / 4 + (isActive ? fontSize / 9 : 0),
        ),
        decoration: BoxDecoration(
          color: isActive ? color.darker : null,
          borderRadius: BorderRadius.all(Radius.circular(fontSize / 4)),
          border: isActive
              ? null
              : Border.all(color: color.darker, width: fontSize / 9),
        ),
        child: Text(
          "#" + label,
          style: TextStyle(
              color: isActive ? color.lighter : color.darker,
              fontSize: fontSize),
        ),
      ),
      onPressed: onPressed,
    );
  }
}

class Tags extends StatelessWidget {
  final List<TagInfos> tags;
  final Nuance color;
  final double fontSize;

  const Tags({
    Key? key,
    required this.tags,
    required this.color,
    this.fontSize = 18,
  }) : super(key: key);

  static Tags static(
    List<String> labels, {
    required Nuance color,
    bool active = false,
    double fontSize = 18,
  }) {
    return Tags(
      tags: labels.map((l) => TagInfos(label: l, isActive: active)).toList(),
      color: color,
      fontSize: fontSize,
    );
  }

  List<Widget> _tagsList(List<TagInfos> tags) {
    return tags
        .map((t) => Tag(
              label: t.label,
              isActive: t.isActive,
              color: color,
              onPressed: t.onTap,
              fontSize: fontSize,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        children: [
          ..._tagsList(tags.where((t) => t.isActive).toList()),
          ..._tagsList(
            tags.where((t) => !t.isActive).toList(),
          )
        ]);
  }
}
