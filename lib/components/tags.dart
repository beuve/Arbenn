import 'package:arbenn/components/buttons.dart';
import 'package:arbenn/components/inputs.dart';
import 'package:arbenn/components/overlay.dart';
import 'package:arbenn/utils/colors.dart';
import 'package:arbenn/utils/icons.dart';
import 'package:flutter/material.dart';
import '../data/tags_data.dart';

class Tag extends StatelessWidget {
  final String label;
  final bool isActive;
  final Nuance color;
  final ColorTheme colorTheme;
  final Function()? onPressed;
  final double fontSize;

  const Tag(
      {Key? key,
      required this.label,
      required this.color,
      this.onPressed,
      this.colorTheme = ColorTheme.light,
      this.fontSize = 18,
      this.isActive = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color outlineColor =
        colorTheme == ColorTheme.light ? color.lighter : color.darker;
    Color backgroundColor =
        colorTheme == ColorTheme.light ? color.darker : color.lighter;
    return TextButton(
      child: Container(
        margin: const EdgeInsets.only(bottom: 6, right: 6),
        padding: EdgeInsets.symmetric(
          horizontal: fontSize / 3 + (isActive ? fontSize / 9 : 0),
          vertical: fontSize / 4 + (isActive ? fontSize / 9 : 0),
        ),
        decoration: BoxDecoration(
          color: isActive ? backgroundColor : null,
          borderRadius: BorderRadius.all(Radius.circular(fontSize / 4)),
          border: isActive
              ? null
              : Border.all(color: backgroundColor, width: fontSize / 9),
        ),
        child: Text(
          "#" + label,
          style: TextStyle(
              color: isActive ? outlineColor : backgroundColor,
              fontSize: fontSize),
        ),
      ),
      onPressed: onPressed,
    );
  }
}

class Tags extends StatelessWidget {
  final List<TagWidgetInfos> tags;
  final Nuance color;
  final double fontSize;
  final ColorTheme colorTheme;
  final Function()? addAction;

  const Tags({
    Key? key,
    required this.tags,
    required this.color,
    this.addAction,
    this.colorTheme = ColorTheme.light,
    this.fontSize = 18,
  }) : super(key: key);

  static Tags static(List<TagData> tags,
      {required Nuance color,
      bool active = false,
      double fontSize = 18,
      ColorTheme colorTheme = ColorTheme.light,
      Function()? addAction}) {
    return Tags(
      tags: tags.map((t) => TagWidgetInfos(data: t, isActive: active)).toList(),
      color: color,
      fontSize: fontSize,
      colorTheme: colorTheme,
      addAction: addAction,
    );
  }

  List<Widget> _tagsList(List<TagWidgetInfos> tags) {
    return tags
        .map((t) => Tag(
              label: t.data.label,
              isActive: t.isActive,
              color: color,
              onPressed: t.onTap,
              fontSize: fontSize,
              colorTheme: colorTheme,
            ))
        .toList();
  }

  Widget _addButton() {
    final Color outlineColor =
        colorTheme == ColorTheme.light ? color.lighter : color.darker;
    final Color backgroundColor =
        colorTheme == ColorTheme.light ? color.darker : color.lighter;
    return TextButton(
        child: Container(
          margin: const EdgeInsets.only(bottom: 6, right: 6),
          padding: EdgeInsets.symmetric(
            horizontal: fontSize / 2,
            vertical: fontSize / 12,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(fontSize / 4)),
          ),
          child: Text("+",
              style: TextStyle(color: outlineColor, fontSize: fontSize * 1.5)),
        ),
        onPressed: addAction);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        children: [
          ..._tagsList(tags.where((t) => t.isActive).toList()),
          if (addAction != null) _addButton(),
          ..._tagsList(
            tags.where((t) => !t.isActive).toList(),
          )
        ]);
  }
}

class SearchTagsWidget extends StatefulWidget {
  final Nuance color;
  final Function(List<TagData>) onFinish;
  final List<TagData> initTags;

  const SearchTagsWidget({
    required this.color,
    required this.onFinish,
    this.initTags = const [],
    Key? key,
  }) : super(key: key);

  @override
  State<SearchTagsWidget> createState() => _SearchTagsWidgetState();
}

class _SearchTagsWidgetState extends State<SearchTagsWidget> {
  late TagSearch _tagSearch;

  @override
  void initState() {
    _tagSearch = TagSearch();
    _tagSearch.setSelectedTags(widget.initTags, setState);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FullPageOverlay(
      title: "TAGS",
      color: widget.color,
      body: Column(
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
                      color: widget.color,
                      onChanged: (query) async {
                        await _tagSearch.newSearch(query, setState);
                        setState(() => {});
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Tags(tags: _tagSearch.tags, color: widget.color),
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            child: Button(
                color: widget.color,
                label: "VALIDER",
                onPressed: () => widget
                    .onFinish(_tagSearch.tags.map((t) => t.data).toList())),
          )
        ],
      ),
    );
  }
}
