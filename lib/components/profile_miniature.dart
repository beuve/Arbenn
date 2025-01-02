import 'package:arbenn/data/user/user_data.dart';
import 'package:arbenn/data/user/authentication.dart';
import 'package:flutter/material.dart';

Image getNetImage(String? url, double size) {
  if (url == null) {
    return Image.asset(
      'assets/images/user_placeholder.png',
      height: size,
      width: size,
    );
  }
  return Image.network(
    url,
    height: size,
    width: size,
    errorBuilder: (context, error, stackTrace) => Image.asset(
      'assets/images/user_placeholder.png',
      height: size,
      width: size,
    ),
  );
}

class ProfileMiniature extends StatefulWidget {
  final String? pictureUrl;
  final double size;
  final bool border;
  const ProfileMiniature({
    super.key,
    required this.pictureUrl,
    this.size = 20,
    this.border = false,
  });

  static Widget fromUserId(int userId,
      {required Credentials creds, double size = 20}) {
    return FutureBuilder<UserSumarryData?>(
      future: UserSumarryData.loadFromUserId(userId, creds: creds),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ProfileMiniature(
            pictureUrl: snapshot.data?.pictureUrl,
            size: size,
          );
        } else {
          return ProfileMiniature(
            pictureUrl: null,
            size: size,
          );
        }
      },
    );
  }

  @override
  State<ProfileMiniature> createState() => _ProfileMiniatureState();
}

class _ProfileMiniatureState extends State<ProfileMiniature> {
  late ImageProvider<Object> _image;

  @override
  void initState() {
    _image = widget.pictureUrl == null
        ? const AssetImage('assets/images/user_placeholder.png')
        : NetworkImage(widget.pictureUrl!) as ImageProvider<Object>;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.border ? const EdgeInsets.all(6) : null,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(widget.size),
      ),
      width: widget.size,
      height: widget.size,
      child: CircleAvatar(
        backgroundImage: _image,
        onBackgroundImageError: ((exception, stackTrace) => setState(
              () => _image =
                  const AssetImage('assets/images/user_placeholder.png'),
            )),
      ),
    );
  }
}
