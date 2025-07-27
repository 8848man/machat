import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/router/lib.dart';

class MCToken extends ConsumerWidget {
  const MCToken({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.read(goRouterProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => router.goNamed(RouterPath.token.name),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 60, maxHeight: 20),
          decoration: BoxDecoration(
            border: Border.all(color: MCColors.$color_blue_40),
            borderRadius: BorderRadius.circular(8),
            color: MCColors.$color_grey_20,
          ),
          child: const Center(
            child: Text('1500P'),
          ),
        ),
      ),
    );
  }
}
