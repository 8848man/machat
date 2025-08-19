import 'package:flutter/material.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/features/study/features/voca/models/word_model.dart';

String getMasteryLevel(WordMasteryLevel level) {
  return level.name;
}

Color getMasteryColor(WordMasteryLevel mLevel) {
  switch (mLevel) {
    case WordMasteryLevel.unknown:
      return MCColors.$color_grey_30;
    case WordMasteryLevel.confused:
      return MCColors.$color_orange_30;
    case WordMasteryLevel.mastered:
      return MCColors.$color_blue_30;
  }
}
