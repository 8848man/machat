import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/ai/utils/ai_controller_manager.dart';

class AiBody extends ConsumerWidget {
  final AiModelControllerManager aiModelManager;
  const AiBody({super.key, required this.aiModelManager});

  final List<String> labels = const [
    '이름',
    '설명',
    '특징 (쉼표로 구분)',
    '말하기 스타일',
    '역할',
    '프롬프트'
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ...List.generate(6, (index) {
          return inputField(aiModelManager.controllers[index], labels[index]);
        }),
      ],
    );
  }

  Widget inputField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
