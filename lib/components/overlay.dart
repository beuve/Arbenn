import 'package:flutter/material.dart' hide BackButton;
import '../utils/colors.dart';
import '../components/buttons.dart';

class FullPageOverlay extends StatelessWidget {
  final Nuance color;
  final String title;
  final Widget body;

  const FullPageOverlay({
    Key? key,
    required this.color,
    required this.title,
    required this.body,
  }) : super(key: key);

  _buildHeader() {
    return Container(
        color: color.lighter,
        child: Column(children: [
          Stack(
            children: [
              Container(
                height: 78,
                alignment: Alignment.center,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 30,
                    color: color.darker,
                  ),
                ),
              ),
              Container(
                height: 78,
                alignment: Alignment.centerLeft,
                child: BackButton(
                  color: color,
                ),
              ),
            ],
          ),
          Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(color: color.darker)),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color.lighter,
      child: SafeArea(
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(80.0),
              child: _buildHeader(),
            ),
            body: ColoredBox(color: color.lighter, child: body)),
      ),
    );
  }
}
