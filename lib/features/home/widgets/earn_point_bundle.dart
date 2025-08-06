import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/features/common/animated_widgets/mc_appear.dart';
import 'package:machat/features/home/view_models/earn_point_view_model.dart';
import 'package:machat_token_service/features/commons/widgets/lib.dart';

class EarnPointBundle extends ConsumerWidget {
  const EarnPointBundle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notiifer = ref.read(earnPointViewModelProvider.notifier);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 500,
          ),
          child: Column(
            children: [getPointSection(notiifer)],
          ),
        ),
      ),
    );
  }

  Widget getPointSection(EarnPointViewModel notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: McAppear(
            delayMs: 200,
            child: Text(
              '포인트를 더 얻을 수 있어요',
              style: TextStyle(
                color: MCColors.$color_blue_70,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        studyEnglishCard(notifier),
      ],
    );
  }

  Widget studyEnglishCard(EarnPointViewModel notifier) {
    return GestureDetector(
      onTap: () => notifier.goStudyEnglish(),
      child: const CardFrame(
        child: Text("영어 공부 카드"),
      ),
    );
  }
}
