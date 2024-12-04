part of '../lib.dart';

const double _dsSpace = 16;

class MCSpace {
  // 가로 여백 박스
  Widget horizontalSpace() {
    return const SizedBox(
      width: _dsSpace,
    );
  }

  // 세로 여백 박스
  Widget verticalSpace() {
    return const SizedBox(
      height: _dsSpace,
    );
  }
}
