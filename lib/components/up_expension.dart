// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:arbenn/utils/colors.dart';

const Duration _kExpand = Duration(milliseconds: 100);

class _UpExpansionTile extends StatefulWidget {
  const _UpExpansionTile({
    Key? key,
    required this.header,
    this.onExpansionChanged,
    required this.child,
    this.expandedCrossAxisAlignment,
    this.backgroundColor,
  })  : assert(
          expandedCrossAxisAlignment != CrossAxisAlignment.baseline,
          'CrossAxisAlignment.baseline is not supported since the expanded children '
          'are aligned in a column, not a row. Try to use another constant.',
        ),
        super(key: key);

  final Widget header;
  final ValueChanged<bool>? onExpansionChanged;
  final Widget child;
  final Color? backgroundColor;
  final CrossAxisAlignment? expandedCrossAxisAlignment;

  @override
  State<_UpExpansionTile> createState() => UpTileState();
}

class UpTileState extends State<_UpExpansionTile>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.linear);

  late AnimationController _controller;
  late Animation<double> _heightFactor;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);

    _isExpanded = PageStorage.of(context)?.readState(context) as bool? ?? false;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void expand() => _setExpanded(true);

  void collapse() => _setExpanded(false);

  void toggle() => _setExpanded(!_isExpanded);

  void updatePosition(Offset o) {
    _controller.animateTo(_heightFactor.value - o.direction * o.distance / 10);
  }

  void _setExpanded(bool isExpanded) {
    if (_isExpanded != isExpanded) {
      setState(() {
        _isExpanded = !_isExpanded;
        if (_isExpanded) {
          _controller.forward();
        } else {
          _controller.reverse().then<void>((void value) {
            if (!mounted) return;
            setState(() {
              // Rebuild without widget.children.
            });
          });
        }
        PageStorage.of(context)?.writeState(context, _isExpanded);
      });
    }
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context)?.writeState(context, _isExpanded);
    });
    widget.onExpansionChanged?.call(_isExpanded);
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.transparent,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            onVerticalDragUpdate: (dragUpdate) {
              updatePosition(dragUpdate.delta);
            },
            onTap: _handleTap,
            child: widget.header,
          ),
          ClipRect(
            child: Align(
              alignment: Alignment.center,
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    final bool shouldRemoveChildren = closed;

    final Widget result = Offstage(
      offstage: closed,
      child: TickerMode(
        enabled: !closed,
        child: widget.child,
      ),
    );

    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: shouldRemoveChildren ? null : result,
    );
  }
}

Widget tileUp({
  required Nuance color,
  required GlobalKey<dynamic> key,
  required Widget child,
  required List<GlobalKey<dynamic>> concurrentKeys,
  required String label,
  double headerHeight = 80,
  Color? background,
}) {
  return _UpExpansionTile(
    key: key,
    backgroundColor: background,
    header: Container(
      width: double.infinity,
      height: headerHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: color.lighter,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          )),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 5,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            decoration: BoxDecoration(
              color: color.darker,
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 30, color: color.darker),
          ),
        ],
      ),
    ),
    onExpansionChanged: (isActive) {
      for (var key in concurrentKeys) {
        key.currentState?.collapse();
      }
    },
    child: Container(
      decoration: BoxDecoration(color: color.lighter),
      child: child,
    ),
  );
}
