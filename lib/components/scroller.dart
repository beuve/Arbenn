import 'package:flutter/material.dart' hide IconButton, BackButton;
import 'dart:async';

class ScrollList extends StatefulWidget {
  final List<Widget> children;
  final Future<void> Function()? onRefresh;
  final bool reverse;

  const ScrollList(
      {super.key,
      required this.children,
      this.reverse = false,
      this.onRefresh});

  @override
  State<ScrollList> createState() => _ScrollListState();
}

class _ScrollListState extends State<ScrollList> {
  final ScrollController _scrollControl = ScrollController();
  late bool _showTopShadow;

  void _scrollListener() {
    if (_scrollControl.hasClients) {
      if (_scrollControl.position.maxScrollExtent == 0) {
        setState(() => _showTopShadow = false);
      } else if (_scrollControl.offset <=
          _scrollControl.position.minScrollExtent +
              _scrollControl.position.maxScrollExtent * 0.05) {
        setState(() => _showTopShadow = false);
      } else {
        setState(() => _showTopShadow = true);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _showTopShadow = false;
    _scrollControl.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_scrollControl.position.maxScrollExtent == 0) {
        Future.delayed(const Duration(milliseconds: 100), () {
          _scrollListener();
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget list = ListView.builder(
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      reverse: widget.reverse,
      physics: widget.onRefresh != null
          ? const AlwaysScrollableScrollPhysics()
          : const ClampingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return widget.children[index];
      },
      itemCount: widget.children.length,
      controller: _scrollControl,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        border: Border(
          top: _showTopShadow
              ? BorderSide(width: 1, color: Colors.grey[500]!)
              : BorderSide.none,
        ),
      ),
      child: widget.onRefresh != null
          ? RefreshIndicator(
              onRefresh: widget.onRefresh!,
              color: Colors.black,
              backgroundColor: Colors.white,
              child: list,
            )
          : list,
    );
  }
}

class ScrollSingle extends StatefulWidget {
  final Widget child;
  final Color shadowColor;

  const ScrollSingle({
    super.key,
    required this.child,
    required this.shadowColor,
  });

  @override
  State<ScrollSingle> createState() => _ScrollSingleState();
}

class _ScrollSingleState extends State<ScrollSingle> {
  final ScrollController _scrollControl = ScrollController();
  late bool _showTopShadow;

  void _scrollListener() {
    if (_scrollControl.hasClients) {
      if (_scrollControl.position.maxScrollExtent == 0) {
        setState(() => _showTopShadow = false);
      } else if (_scrollControl.offset <=
          _scrollControl.position.minScrollExtent +
              _scrollControl.position.maxScrollExtent * 0.05) {
        setState(() => _showTopShadow = false);
      } else {
        setState(() => _showTopShadow = true);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _showTopShadow = false;
    _scrollControl.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border(
          top: _showTopShadow
              ? BorderSide(width: 1, color: widget.shadowColor)
              : BorderSide.none,
        ),
      ),
      child: SingleChildScrollView(
        controller: _scrollControl,
        child: widget.child,
      ),
    );
  }
}
