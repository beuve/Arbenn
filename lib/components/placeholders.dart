import 'package:flutter/material.dart';

class TextPlaceholder extends StatelessWidget {
  final Color color;
  final double width, height;
  final IconData? icon;

  const TextPlaceholder({
    super.key,
    this.width = 60,
    this.height = 10,
    this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> elements = [
      if (icon != null) Icon(icon, size: 12, color: color),
      Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
      )
    ];

    return elements.length == 1 ? elements[0] : Row(children: elements);
  }
}

class TickingBuilder extends StatefulWidget {
  final Widget Function(BuildContext, double) builder;
  final Duration duration;

  const TickingBuilder({
    super.key,
    required this.builder,
    this.duration = const Duration(seconds: 1, milliseconds: 500),
  });

  @override
  State<TickingBuilder> createState() => _TickingBuilderState();
}

class _TickingBuilderState extends State<TickingBuilder>
    with TickerProviderStateMixin {
  late AnimationController animate;
  late double _value;

  @override
  initState() {
    super.initState();
    _value = 0;
    animate = AnimationController(duration: widget.duration, vsync: this);
    animate.repeat(reverse: true);
    animate.addListener(() {
      setState(() => _value = animate.value);
    });
  }

  @override
  void dispose() {
    animate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _value);
  }
}
