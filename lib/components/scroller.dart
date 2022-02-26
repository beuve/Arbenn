import 'package:flutter/material.dart' hide IconButton, BackButton;
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'dart:async';

enum ScrollState {
  top,
  bottom,
  middle,
  none,
}

class ScrollList extends StatefulWidget {
  final List<Widget> children;
  final Color shadowColor;
  final Future<void> Function()? onRefresh;
  final bool reverse;

  const ScrollList(
      {Key? key,
      required this.children,
      required this.shadowColor,
      this.reverse = false,
      this.onRefresh})
      : super(key: key);

  @override
  State<ScrollList> createState() => _ScrollListState();
}

class _ScrollListState extends State<ScrollList> {
  final ScrollController _scrollControl = ScrollController();
  late ScrollState _scrollState;

  late StreamSubscription<bool> _keyboardSubscription;

  void _scrollListener() {
    if (_scrollControl.hasClients) {
      if (_scrollControl.position.maxScrollExtent == 0) {
        setState(() => _scrollState = ScrollState.none);
      } else if (_scrollControl.offset >=
          _scrollControl.position.maxScrollExtent) {
        setState(() => _scrollState = ScrollState.bottom);
      } else if (_scrollControl.offset <=
          _scrollControl.position.minScrollExtent) {
        setState(() => _scrollState = ScrollState.top);
      } else {
        setState(() => _scrollState = ScrollState.middle);
      }
    }
  }

  bool hasBottomHidedInfos() {
    if (_scrollState == ScrollState.middle) {
      return true;
    }
    if (widget.reverse && _scrollState == ScrollState.bottom) {
      return true;
    }
    if (!widget.reverse && _scrollState == ScrollState.top) {
      return true;
    }
    return false;
  }

  bool hasTopHidedInfos() {
    if (_scrollState == ScrollState.middle) {
      return true;
    }
    if (widget.reverse && _scrollState == ScrollState.top) {
      return true;
    }
    if (!widget.reverse && _scrollState == ScrollState.bottom) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _scrollState = widget.reverse ? ScrollState.bottom : ScrollState.top;
    _scrollControl.addListener(_scrollListener);
    _keyboardSubscription =
        KeyboardVisibilityController().onChange.listen((bool visible) {
      Future.delayed(const Duration(milliseconds: 200), () {
        _scrollListener();
      });
    });
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
    _keyboardSubscription.cancel();
    _scrollControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget list = ListView.builder(
      scrollDirection: Axis.vertical,
      reverse: widget.reverse,
      itemBuilder: (BuildContext context, int index) {
        return widget.children[index];
      },
      itemCount: widget.children.length,
      controller: _scrollControl,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: widget.onRefresh != null
          ? RefreshIndicator(child: list, onRefresh: widget.onRefresh!)
          : list,
      decoration: BoxDecoration(
        border: Border(
          top: hasTopHidedInfos()
              ? BorderSide(width: 1, color: widget.shadowColor)
              : BorderSide.none,
          bottom: hasBottomHidedInfos()
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
