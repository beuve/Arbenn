import 'dart:ui';
import 'package:arbenn/components/inputs.dart';
import 'package:arbenn/components/overlay.dart';
import 'package:flutter/material.dart';
import 'package:arbenn/data/tags_data.dart';

class StaticTag extends StatelessWidget {
  final TagData data;
  final double fontSize;

  const StaticTag(
    this.data, {
    this.fontSize = 10,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: data.nuances.lighter,
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      child: Row(
        children: [
          Text(
            data.label,
            style: TextStyle(color: data.nuances.darker, fontSize: fontSize),
          ),
        ],
      ),
    );
  }
}

class StaticTags extends StatelessWidget {
  final List<TagData> labels;
  final double fontSize;

  const StaticTags(
    this.labels, {
    this.fontSize = 10,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final tags = labels
        .map((l) => WidgetSpan(
            child: Container(
                margin: const EdgeInsets.only(right: 5),
                child: FittedBox(child: StaticTag(l, fontSize: fontSize)))))
        .toList();
    return RichText(maxLines: 2, text: TextSpan(children: tags));
  }
}

class StaticGlassTag extends StatelessWidget {
  final String label;
  final IconData? icon;

  const StaticGlassTag(
    this.label, {
    super.key,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          color: Colors.black.withAlpha(40),
          padding: const EdgeInsets.all(6),
          child: Row(
            children: [
              if (icon != null)
                Icon(
                  icon,
                  size: 15,
                  color: Colors.white,
                ),
              Text(
                label,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Tag extends StatelessWidget {
  final String label;
  final bool isActive;
  final Function()? onPressed;
  final double fontSize;

  const Tag({
    super.key,
    required this.label,
    this.onPressed,
    this.isActive = false,
    this.fontSize = 10,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = isActive ? Colors.blue : Colors.blue[50]!;
    Color foregroundColor = isActive ? Colors.white : Colors.blue;
    return TextButton(
      onPressed: onPressed,
      child: Container(
        margin: const EdgeInsets.only(bottom: 6, right: 6),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: foregroundColor,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}

class Tags extends StatelessWidget {
  final List<TagWidgetInfos> tags;
  final double fontSize;
  final int? maxLines;
  final TextAlign align;

  const Tags({
    super.key,
    required this.tags,
    this.align = TextAlign.center,
    this.maxLines,
    this.fontSize = 15,
  });

  List<InlineSpan> _tagsList(List<TagWidgetInfos> tags) {
    return tags
        .map((t) => WidgetSpan(
                child: Tag(
              label: t.data.label,
              isActive: t.isActive,
              onPressed: t.onTap,
              fontSize: fontSize,
            )))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
        textAlign: align,
        maxLines: maxLines,
        text: TextSpan(children: [
          ..._tagsList(tags.where((t) => t.isActive).toList()),
          ..._tagsList(
            tags.where((t) => !t.isActive).toList(),
          )
        ]));
  }
}

class SearchTagsWidget extends StatefulWidget {
  final Function(List<TagData>) onFinish;
  final List<TagData> initTags;

  const SearchTagsWidget({
    required this.onFinish,
    this.initTags = const [],
    super.key,
  });

  @override
  State<SearchTagsWidget> createState() => _SearchTagsWidgetState();
}

class _SearchTagsWidgetState extends State<SearchTagsWidget> {
  late TagSearch _tagSearch;

  @override
  void initState() {
    _tagSearch = TagSearch();
    _tagSearch.setSelectedTags(widget.initTags, () {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FullPageOverlay(
      title: "chercher des tags",
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      margin: const EdgeInsets.only(bottom: 30),
                      child: SearchInput(
                        label: "Chercher des tags...",
                        onChanged: (query) async {
                          await _tagSearch.newSearch(query, () => {});
                          setState(() => {});
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Tags(tags: _tagSearch.tags),
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: ElevatedButton(
                  child: const Text("VALIDER"),
                  onPressed: () => widget.onFinish(_tagSearch.tags
                      .where((t) => t.isActive)
                      .map((t) => t.data)
                      .toList())),
            )
          ],
        ),
      ),
    );
  }
}
