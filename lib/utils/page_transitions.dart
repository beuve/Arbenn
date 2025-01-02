import 'package:flutter/material.dart';

enum Side { left, right, down, up }

Route slideIn(Widget child, {Side side = Side.right}) {
  final double horizontalOffset = side == Side.left
      ? -1
      : side == Side.right
          ? 1
          : 0;
  final double verticalOffset = side == Side.up
      ? -1
      : side == Side.down
          ? 1
          : 0;
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final begin = Offset(horizontalOffset, verticalOffset);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
