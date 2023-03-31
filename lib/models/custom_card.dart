import 'dart:ui';
import 'package:flutter/src/widgets/image.dart';

class FriendsCard {
  final String name;
  final Image image;
  final int value;
  late double transparency = 1;
  late bool active;
  late bool done = false;

  FriendsCard(this.name, this.image, this.value, this.active);
}
