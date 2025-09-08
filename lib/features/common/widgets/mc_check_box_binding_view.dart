import 'package:flutter/material.dart';
import 'package:machat/design_system/lib.dart';

class MCCheckBoxBindigView extends StatelessWidget {
  final bool value; // 외부에서 내려주는 체크 상태
  final VoidCallback? onTap; // 체크 시 호출되는 콜백
  final double? scale;
  final Color? color;

  const MCCheckBoxBindigView({
    super.key,
    required this.value,
    this.onTap,
    this.scale,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return MCCheckbox(
      scale: scale,
      color: color,
      isChecked: value,
      onChanged: (newValue) {
        // 체크 해제 불가: 이미 true이면 무시
        if (!value && (newValue ?? false)) {
          onTap?.call();
        }
      },
    );
  }
}
