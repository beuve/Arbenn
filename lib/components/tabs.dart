import 'package:flutter/material.dart' hide IconButton, BackButton;
import '../utils/colors.dart';

class TabInfos {
  final String title;
  final Widget content;

  const TabInfos({required this.content, required this.title});
}

class Tabs extends StatefulWidget {
  final List<TabInfos> tabs;
  final Nuance color;
  final int startingTab;

  const Tabs({
    Key? key,
    required this.tabs,
    required this.color,
    this.startingTab = 0,
  }) : super(key: key);

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  late int _current;

  @override
  void initState() {
    super.initState();
    _current = widget.startingTab;
  }

  void _setTab(int i) {
    setState(() {
      _current = i;
    });
  }

  Widget _buildTabs() {
    List<Widget> tabsWidgets = [];
    for (var i = 0; i < widget.tabs.length; i++) {
      tabsWidgets.add(
        Expanded(
          child: TextButton(
            onPressed: () => _setTab(i),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: _current == i ? widget.color.lighter : widget.color.dark,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(25),
                  topRight: const Radius.circular(25),
                  bottomLeft: _current == i - 1
                      ? const Radius.circular(25)
                      : Radius.zero,
                  bottomRight: _current == i + 1
                      ? const Radius.circular(25)
                      : Radius.zero,
                ),
              ),
              child: Text(widget.tabs[i].title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: _current == i
                        ? widget.color.darker
                        : widget.color.lighter,
                  )),
            ),
          ),
        ),
      );
    }
    return Row(children: tabsWidgets);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        margin: const EdgeInsets.only(top: 25),
        color: widget.color.lighter,
        width: double.infinity,
        height: 25,
      ),
      _buildTabs(),
      Container(
        margin: const EdgeInsets.only(top: 50),
        color: widget.color.lighter,
        child: widget.tabs[_current].content,
      ),
    ]);
  }
}
