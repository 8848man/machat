part of '../lib.dart';

const double _dsPadding = 16;

class DSPadding {
  // All directions
  EdgeInsets all() {
    return const EdgeInsets.all(_dsPadding);
  }

  // Symmetric padding with customizable vertical and horizontal padding
  EdgeInsets symmetric({bool vertical = false, bool horizontal = false}) {
    return EdgeInsets.symmetric(
      vertical: vertical ? _dsPadding : 0,
      horizontal: horizontal ? _dsPadding : 0,
    );
  }

  // Padding for only the left side
  EdgeInsets left() {
    return const EdgeInsets.only(left: _dsPadding);
  }

  // Padding for only the right side
  EdgeInsets right() {
    return const EdgeInsets.only(right: _dsPadding);
  }

  // Padding for only the top side
  EdgeInsets top() {
    return const EdgeInsets.only(top: _dsPadding);
  }

  // Padding for only the bottom side
  EdgeInsets bottom() {
    return const EdgeInsets.only(bottom: _dsPadding);
  }

  // Padding for left and right
  EdgeInsets horizontal() {
    return const EdgeInsets.symmetric(horizontal: _dsPadding);
  }

  // Padding for top and bottom
  EdgeInsets vertical() {
    return const EdgeInsets.symmetric(vertical: _dsPadding);
  }

  /// 각 방향별로 패딩을 적용합니다.
  EdgeInsets directional({
    bool left = false,
    bool top = false,
    bool right = false,
    bool bottom = false,
  }) {
    return EdgeInsets.only(
      left: left ? _dsPadding : 0,
      top: top ? _dsPadding : 0,
      right: right ? _dsPadding : 0,
      bottom: bottom ? _dsPadding : 0,
    );
  }
}
