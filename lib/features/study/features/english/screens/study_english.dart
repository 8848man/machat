import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/common/layouts/lib.dart';

class StudyEnglish extends ConsumerWidget {
  const StudyEnglish({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const DefaultLayout(
      needLogin: true,
      child: Center(
        child: Text('영어 학습 페이지!'),
      ),
    );
  }
}
