import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/home/view_models/earn_point_view_model.dart';
import 'package:machat_token_service/features/commons/widgets/lib.dart';

class EarnPointBundle extends ConsumerWidget {
  const EarnPointBundle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notiifer = ref.read(earnPointViewModelProvider.notifier);
    return SingleChildScrollView(
      child: Column(
        children: [studyEnglishCard(notiifer)],
      ),
    );
  }

  Widget studyEnglishCard(EarnPointViewModel notifier) {
    return GestureDetector(
      onTap: () => notifier.goStudyEnglish(),
      child: CardFrame(
        child: Text("영어 공부 카드"),
      ),
    );
  }
}
