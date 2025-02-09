import 'dart:ui';

import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:arbenn/utils/errors/result.dart';
import 'package:flutter/material.dart';

class BackButton extends StatelessWidget {
  final Function()? onPressed;
  final Color color;

  const BackButton({
    super.key,
    this.onPressed,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed ?? () => Navigator.pop(context),
      child: Icon(
        AkarIcons.arrow_left,
        size: 25,
        color: color,
      ),
    );
  }
}

class GlassBackButton extends StatelessWidget {
  final Function()? onPressed;

  const GlassBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => Navigator.pop(context),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 15.0,
            sigmaY: 15.0,
          ),
          child: const SizedBox(
            width: 45,
            height: 45,
            child: Icon(
              AkarIcons.chevron_left_small,
              size: 25,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class FilledSquareButton extends StatelessWidget {
  final Function()? onTap;
  final IconData icon;

  const FilledSquareButton({
    super.key,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
        child: GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.blue[700],
              ),
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Icon(
                  icon,
                  size: 28,
                  color: Colors.white,
                ),
              ),
            )));
  }
}

class SquareButton extends StatelessWidget {
  final Function()? onTap;
  final IconData icon;
  final Color borderColor;
  final Color iconColor;

  const SquareButton({
    super.key,
    required this.icon,
    this.borderColor = Colors.black12,
    this.iconColor = Colors.black,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
        child: GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: borderColor),
              ),
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  icon,
                  size: 25,
                  color: iconColor,
                ),
              ),
            )));
  }
}

class NavButton extends StatelessWidget {
  final Function()? onPressed;
  final IconData icon;
  final bool isActive;

  const NavButton({
    super.key,
    required this.icon,
    required this.isActive,
    this.onPressed,
  });

  Widget _buildIcon() {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Icon(
        icon,
        size: 25,
        color: isActive ? Colors.blue : Colors.black26,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Stack(alignment: AlignmentDirectional.center, children: [
      if (isActive)
        Container(
            margin: const EdgeInsets.only(top: 50),
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            )),
      TextButton(
        onPressed: onPressed,
        child: Container(
          height: 40,
          alignment: Alignment.bottomCenter,
          child: _buildIcon(),
        ),
      ),
    ]));
  }
}

class SettingButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color color;
  final Function() onPressed;

  const SettingButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = Colors.black,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 10)
            ],
            Container(
              alignment: Alignment.centerLeft,
              height: 30,
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 15,
                ),
              ),
            ),
            Expanded(child: Container()),
            Container(
              alignment: Alignment.centerRight,
              child: Icon(
                AkarIcons.chevron_right_small,
                size: 20,
                color: Colors.grey[400],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FutureButton extends StatefulWidget {
  final String label;
  final Future<Result<()>> Function() onPressed;
  final void Function()? onEnd;

  const FutureButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.onEnd,
  });

  @override
  State<FutureButton> createState() => _FutureButtonState();
}

enum _ButtonState { waiting, done, running, error }

class _FutureButtonState extends State<FutureButton>
    with TickerProviderStateMixin {
  late _ButtonState _state;

  @override
  void initState() {
    super.initState();
    _state = _ButtonState.waiting;
  }

  void onPressed() async {
    setState(() {
      _state = _ButtonState.running;
    });
    final res = await widget.onPressed();
    if (res.isErr()) {
      setState(() {
        _state = _ButtonState.error;
      });
    } else {
      setState(() {
        _state = _ButtonState.done;
      });
    }
    await Future.delayed(const Duration(milliseconds: 500));
    if (widget.onEnd != null) {
      widget.onEnd!();
    }
    if (res.isErr()) {
      setState(() {
        _state = _ButtonState.waiting;
      });
    }
  }

  Widget _waitingContent() {
    return const Icon(
      AkarIcons.check,
      size: 20,
    );
  }

  Widget _doneContent() {
    return const Icon(
      AkarIcons.check,
      size: 20,
    );
  }

  Widget _errorContent() {
    return const Icon(
      AkarIcons.cross,
      size: 20,
    );
  }

  Widget _runningContent() {
    return const SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    late Widget content;
    if (_state == _ButtonState.waiting) {
      content = _waitingContent();
    } else if (_state == _ButtonState.running) {
      content = _runningContent();
    } else if (_state == _ButtonState.done) {
      content = _doneContent();
    } else {
      content = _errorContent();
    }
    return IconButton(
      onPressed: _state == _ButtonState.waiting ? onPressed : null,
      icon: content,
    );
  }
}
