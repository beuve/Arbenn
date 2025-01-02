import 'package:flutter/material.dart' hide BackButton;
import 'package:arbenn/components/buttons.dart';

class FullPageOverlay extends StatelessWidget {
  final String title;
  final Widget body;

  const FullPageOverlay({
    super.key,
    required this.title,
    required this.body,
  });

  _buildHeader() {
    return Stack(
      children: [
        const BackButton(),
        Align(
          alignment: Alignment.center,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(35.0),
            child: _buildHeader(),
          ),
          body: body,
        ),
      ),
    );
  }
}
