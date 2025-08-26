import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/ai/widgets/ai_bundle.dart';
import 'package:machat/features/common/layouts/lib.dart';

class AiManageScreen extends ConsumerWidget {
  const AiManageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const DefaultLayout(
      child: AiBundle(),
    );
  }
}
