import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/common/layouts/lib.dart';
import 'package:machat/features/study/widgets/subject_widgets.dart';

class StudySubjectScreen extends ConsumerWidget {
  const StudySubjectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const DefaultLayout(
      needLogin: true,
      child: SubjectBundle(),
    );
  }
}
