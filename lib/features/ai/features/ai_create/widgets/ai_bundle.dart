import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/features/ai/features/ai_create/utils/ai_controller_manager.dart';
import 'package:machat/features/ai/features/ai_create/widgets/ai_body.dart';
import 'package:machat/features/ai/features/ai_create/widgets/ai_footer.dart';
import 'package:machat/features/ai/features/ai_create/widgets/ai_header.dart';
import 'package:machat/features/common/layouts/bundle_layout.dart';

class AiBundle extends ConsumerStatefulWidget {
  const AiBundle({super.key});

  @override
  ConsumerState<AiBundle> createState() => _AiBundleState();
}

class _AiBundleState extends ConsumerState<AiBundle> {
  late final AiModelControllerManager aiModelManager;

  @override
  void initState() {
    super.initState();
    aiModelManager = AiModelControllerManager();
  }

  @override
  void dispose() {
    aiModelManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BundleLayout(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AiHeader(),
          const SizedBox(height: 50),
          AiBody(aiModelManager: aiModelManager),
          MCSpace().verticalSpace(),
          AiFooter(aiModelManager: aiModelManager),
        ],
      ),
    );
  }
}
