import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'dart:async';

class FlashingContainer extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Color startingColor;
  final Color endingColor;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width, height;
  final BoxDecoration? decoration;

  const FlashingContainer({
    Key? key,
    required this.child,
    required this.startingColor,
    required this.endingColor,
    this.alignment,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.decoration,
    this.duration = const Duration(seconds: 1),
  }) : super(key: key);

  @override
  State<FlashingContainer> createState() => _FlashingContainerState();
}

class _FlashingContainerState extends State<FlashingContainer>
    with TickerProviderStateMixin {
  late Timer _timer;
  late Color _color;

  @override
  initState() {
    super.initState();
    _color = widget.startingColor;
    _timer = Timer.periodic(widget.duration, (Timer t) {
      if (t.tick % 2 == 0) {
        setState(() => _color = widget.endingColor);
      } else {
        setState(() => _color = widget.startingColor);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(
        () => _color = widget.endingColor)); // Start the animation immediatly
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.linear,
      duration: widget.duration,
      child: widget.child,
      padding: widget.padding,
      margin: widget.margin,
      width: widget.width,
      height: widget.height,
      decoration: widget.decoration == null
          ? BoxDecoration(color: _color)
          : widget.decoration!.copyWith(color: _color),
    );
  }
}
