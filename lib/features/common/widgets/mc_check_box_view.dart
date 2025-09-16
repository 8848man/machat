import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/design_system/lib.dart';

// 1️⃣ Provider를 family로 정의
final checkboxStateProvider = StateProvider.family<bool, String>(
  (ref, id) => false, // 초기값은 false
);

// 2️⃣ 체크박스 뷰 (ID 주입)
class MCCheckBoxView extends ConsumerWidget {
  final String id;
  final double? scale;
  final bool? initValue;

  const MCCheckBoxView({
    super.key,
    required this.id,
    this.scale,
    this.initValue = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ID별 상태를 구독
    final isChecked = ref.watch(checkboxStateProvider(id));

    return MCCheckbox(
      scale: scale,
      isChecked: isChecked,
      onChanged: (value) {
        // 상태 업데이트
        ref.read(checkboxStateProvider(id).notifier).state = value ?? false;
      },
    );
  }
}
