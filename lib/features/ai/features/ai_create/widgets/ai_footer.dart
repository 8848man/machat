import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/features/ai/features/ai_create/utils/ai_controller_manager.dart';
import 'package:machat/features/ai/features/ai_create/view_models/ai_create_view_model.dart';

class AiFooter extends ConsumerWidget {
  final AiModelControllerManager aiModelManager;
  const AiFooter({super.key, required this.aiModelManager});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(aiCreateViewModelProvider.notifier);
    return Column(
      children: [
        MCButtons().getPositiveButton(
          title: '등록하기',
          onTap: () => notifier.createCharacter(aiModelManager.getAiModel()),
          // isLoading: loadingState,
          width: double.infinity,
        ),
        MCSpace().verticalSpace(),
        MCButtons().getNegativeButton(
          title: '취소',
          // onTap: () => notifier.goRegister(),
          width: double.infinity,
        ),
      ],
    );
  }
}
