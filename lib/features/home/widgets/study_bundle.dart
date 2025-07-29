import 'package:flutter/material.dart';
import 'package:machat/features/study/widgets/subject_widgets.dart';

class StudyBundle extends StatelessWidget {
  const StudyBundle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SubjectBundle(),
          ],
        ),
      ),
    );
  }
}
