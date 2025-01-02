import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:flutter/material.dart';

class ImageSelector extends StatelessWidget {
  final List<ImageProvider<Object>> images;
  final Function() onAdd;
  final Function() onDelete;
  final int maxImages;

  const ImageSelector({
    required this.images,
    required this.onAdd,
    required this.onDelete,
    this.maxImages = 5,
    super.key,
  });

  Widget _imageMiniature(ImageProvider image, [double size = 20]) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 7),
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: image,
            ),
          ),
          child: SizedBox(
            width: size,
            height: size,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 82),
          width: 25,
          height: 25,
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(25)),
          child: InkWell(
            onTap: onDelete,
            child: const Icon(
              AkarIcons.cross,
              size: 17,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> photos = images.map((i) => _imageMiniature(i)).toList();
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: <Widget>[
            ...photos,
            if (photos.length < maxImages)
              InkWell(
                onTap: onAdd,
                child: Container(
                  alignment: Alignment.center,
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(right: 10),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Icon(
                      AkarIcons.plus,
                      size: 25,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
