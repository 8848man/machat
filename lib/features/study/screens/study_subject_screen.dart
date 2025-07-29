import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/common/layouts/lib.dart';

class StudySubjectScreen extends ConsumerWidget {
  const StudySubjectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      child: const Center(
        child: Text('study text screen'),
      ),
    );
  }
}
