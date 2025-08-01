import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/design_system/lib.dart';

final checkboxStateProvider = AutoDisposeStateProvider<bool>((ref) => false);

class MCCheckBoxView extends ConsumerWidget {
  const MCCheckBoxView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isChecked = ref.watch(checkboxStateProvider);

    return MCCheckbox(
      isChecked: isChecked,
      onChanged: (value) {
        ref.read(checkboxStateProvider.notifier).state = value ?? false;
      },
    );
  }
}
