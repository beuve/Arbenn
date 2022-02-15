import 'package:flutter/material.dart';

class ProfileMiniature extends StatelessWidget {
  final ImageProvider<Object>? picture;
  final double size;
  const ProfileMiniature({Key? key, required this.picture, this.size = 20})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.fill,
          image:
              picture ?? const AssetImage('assets/images/user_placeholder.png'),
        ),
      ),
    );
  }
}

class ProfileMiniatures extends StatelessWidget {
  final List<ImageProvider<Object>?> pictures;
  final double size;
  const ProfileMiniatures({Key? key, required this.pictures, this.size = 20})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> images = [];
    for (var i = 0; i < pictures.length; i++) {
      images.add(Container(
          padding: EdgeInsets.only(left: i * size / 1.5),
          child: ProfileMiniature(picture: pictures[i], size: size)));
    }
    return Stack(
      children: images,
    );
  }
}
