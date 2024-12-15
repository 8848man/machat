import 'package:flutter/material.dart';
import 'package:machat/design_system/lib.dart';

class GetColor {
  Color? getPositiveColor(value) {
    if (value) return MCColors.$color_blue_40;

    return null;
  }
}
