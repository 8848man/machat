import 'package:flutter/material.dart';

Widget mcPopScope({
  required Widget child,
  required BuildContext context,
  void Function(bool didPop)? onPopInvoked,
}) {
  return PopScope(
    canPop: false, // pop을 직접 제어하기 위해 false로 설정
    onPopInvoked: onPopInvoked ??
        (didPop) {
          if (!didPop) {
            Navigator.of(context).pop(); // 바텀시트 닫기
          }
        },
    child: child,
  );
}
