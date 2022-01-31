import 'package:flutter/material.dart';
import '../utils/colors.dart';

class Button extends StatelessWidget {
  final Nuance color;
  final String label;
  final Function() onPressed;

  const Button(
      {Key? key,
      required this.color,
      required this.label,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        child: Text(
          label,
          style: TextStyle(color: color.lighter, fontSize: 19),
        ),
        decoration: BoxDecoration(
          color: color.darker,
          borderRadius: const BorderRadius.all(Radius.circular(25)),
        ),
      ),
    );
  }
}

class IconButton extends StatelessWidget {
  final Nuance color;
  final IconData icon;
  final Function() onPressed;

  const IconButton(
      {Key? key,
      required this.color,
      required this.icon,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Icon(
          icon,
          size: 20,
          color: color.lighter,
        ),
        decoration: BoxDecoration(
          color: color.darker,
          borderRadius: const BorderRadius.all(Radius.circular(30)),
        ),
      ),
    );
  }
}

class BackButton extends StatelessWidget {
  final Nuance color;
  final Function()? onPressed;

  const BackButton({Key? key, required this.color, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed ?? () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Icon(
          Icons.arrow_back,
          size: 30,
          color: color.darker,
        ),
      ),
    );
  }
}

class NavButton extends StatelessWidget {
  final BorderRadius borderRadius;
  final Function()? onPressed;
  final Widget icon;
  final bool isActive;
  final Nuance color;
  final bool isFirst;
  final bool isLast;

  const NavButton({
    Key? key,
    required this.icon,
    required this.isActive,
    required this.color,
    this.onPressed,
    this.borderRadius = BorderRadius.zero,
    this.isFirst = false,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: TextButton(
        onPressed: onPressed,
        child: Container(
          height: 50,
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: isFirst ? const Radius.circular(25) : Radius.zero,
              topRight: isLast ? const Radius.circular(25) : Radius.zero,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(color: color.darker, spreadRadius: 0),
                    BoxShadow(
                      color: color.main,
                      spreadRadius: 0,
                      offset: Offset(
                          isFirst
                              ? 2
                              : isLast
                                  ? -2
                                  : 0,
                          3),
                    ),
                  ]
                : [],
          ),
          child: icon,
        ),
      ),
    );
  }
}
