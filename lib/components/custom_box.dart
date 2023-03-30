import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/image.dart';

class Custom_Box extends StatelessWidget {
  final Image photo;
  late bool visible;
  final Function(bool) setActive;

  Custom_Box({
    super.key,
    required this.photo,
    required this.visible,
    required this.setActive,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setActive(!visible),
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: visible
              ? DecorationImage(image: photo.image, fit: BoxFit.cover)
              : null,
          color: visible ? null : Colors.white,
        ),
      ),
    );
  }
}
