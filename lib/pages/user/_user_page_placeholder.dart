import 'package:arbenn/components/placeholders.dart';
import 'package:flutter/material.dart';

class ProfilePagePlaceholder extends StatelessWidget {
  final bool backButton;
  final bool editButton;

  const ProfilePagePlaceholder({
    super.key,
    this.backButton = false,
    this.editButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return TickingBuilder(
      builder: (context, tick) => const Text("loading"),
    );
  }
}
