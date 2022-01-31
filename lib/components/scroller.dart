import 'package:flutter/material.dart' hide IconButton, BackButton;

enum ScrollState {
  top,
  bottom,
  middle,
}

class ScrollList extends StatefulWidget {
  final List<Widget> children;
  final Color shadowColor;

  const ScrollList({
    Key? key,
    required this.children,
    required this.shadowColor,
  }) : super(key: key);

  @override
  State<ScrollList> createState() => _ScrollListState();
}

class _ScrollListState extends State<ScrollList> {
  final ScrollController _scrollControl = ScrollController();
  late ScrollState _scrollState;

  void _scrollListener() {
    if (_scrollControl.offset >= _scrollControl.position.maxScrollExtent) {
      setState(() => _scrollState = ScrollState.bottom);
    } else if (_scrollControl.offset <=
        _scrollControl.position.minScrollExtent) {
      setState(() => _scrollState = ScrollState.top);
    } else {
      setState(() => _scrollState = ScrollState.middle);
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollState = ScrollState.top;
    _scrollControl.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          return widget.children[index];
        },
        itemCount: widget.children.length,
        controller: _scrollControl,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: _scrollState != ScrollState.top
              ? BorderSide(width: 1, color: widget.shadowColor)
              : BorderSide.none,
          bottom: _scrollState != ScrollState.bottom
              ? BorderSide(width: 1, color: widget.shadowColor)
              : BorderSide.none,
        ),
      ),
    );
  }
}

class ScrollSingle extends StatefulWidget {
  final Widget child;
  final Color shadowColor;

  const ScrollSingle({
    Key? key,
    required this.child,
    required this.shadowColor,
  }) : super(key: key);

  @override
  State<ScrollSingle> createState() => _ScrollSingleState();
}

class _ScrollSingleState extends State<ScrollSingle> {
  final ScrollController _scrollControl = ScrollController();
  late ScrollState _scrollState;

  void _scrollListener() {
    if (_scrollControl.offset >= _scrollControl.position.maxScrollExtent) {
      setState(() => _scrollState = ScrollState.bottom);
    } else if (_scrollControl.offset <=
        _scrollControl.position.minScrollExtent) {
      setState(() => _scrollState = ScrollState.top);
    } else {
      setState(() => _scrollState = ScrollState.middle);
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollState = ScrollState.top;
    _scrollControl.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: widget.child,
        controller: _scrollControl,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: _scrollState != ScrollState.top
              ? BorderSide(width: 1, color: widget.shadowColor)
              : BorderSide.none,
          bottom: _scrollState != ScrollState.bottom
              ? BorderSide(width: 1, color: widget.shadowColor)
              : BorderSide.none,
        ),
      ),
    );
  }
}
