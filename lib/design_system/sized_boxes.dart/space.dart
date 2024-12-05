part of '../lib.dart';

const double _dsSpace = 16;

class MCSpace {
  // 가로 여백 박스
  Widget horizontalSpace() {
    return const SizedBox(
      width: _dsSpace,
    );
  }

  Widget horizontalHalfSpace() {
    return const SizedBox(
      width: _dsSpace / 2,
    );
  }

  // 세로 여백 박스
  Widget verticalSpace() {
    return const SizedBox(
      height: _dsSpace,
    );
  }

  Widget verticalHalfSpace() {
    return const SizedBox(
      height: _dsSpace / 2,
    );
  }
}
