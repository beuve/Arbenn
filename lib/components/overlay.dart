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

class _FullPageOverlayWithImageHeader extends StatelessWidget {
  final String imageUrl;
  final bool showBackButton;

  const _FullPageOverlayWithImageHeader({
    required this.imageUrl,
    required this.showBackButton,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leadingWidth: 55,
      leading: showBackButton
          ? const Row(
              children: [SizedBox(width: 10), GlassBackButton()],
            )
          : null,
      expandedHeight: 250,
      flexibleSpace: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          FlexibleSpaceBar(
            background: Image.network(imageUrl, fit: BoxFit.cover),
          ),
          Container(
            height: 20,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FullPageOverlayWithImage extends StatelessWidget {
  final Widget body;
  final String imageUrl;
  final bool showBackButton;

  const FullPageOverlayWithImage({
    super.key,
    required this.imageUrl,
    required this.body,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body:
            CustomScrollView(physics: const ClampingScrollPhysics(), slivers: [
          _FullPageOverlayWithImageHeader(
            imageUrl: imageUrl,
            showBackButton: showBackButton,
          ),
          SliverToBoxAdapter(
            child: body,
          ),
        ]),
      ),
    );
  }
}
