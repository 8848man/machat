import 'package:machat/features/home/enums/subject_enum.dart';
import 'package:machat/features/study/models/study.dart';
import 'package:machat/features/study/models/subject.dart';
import 'package:machat/router/lib.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'study_view_model.g.dart';

@riverpod
class StudyViewModel extends _$StudyViewModel {
  @override
  Future<StudyModel> build() async {
    print('test001');
    SubjectList dummySubjectList = getDummySubjectList();
    print('test002');
    return StudyModel(subjectList: dummySubjectList);
  }

  SubjectList getDummySubjectList() {
    List<SubjectModel> subjectList = [];

    final englishModel =
        SubjectModel(title: '영어', progressRate: 0.5, lastVisit: DateTime.now());
    subjectList.add(englishModel);

    return SubjectList(subjectList: subjectList);
  }

  void goSubjectDetail(SubjectEnum subject) {
    // Navigate to the subject detail page
    // This is a placeholder for the actual navigation logic
    print('Navigating to detail page for subject: $subject');
  }

  Future<void> goEnglishPage() async {
    Future.delayed(const Duration(milliseconds: 150), () async {
      final router = ref.read(goRouterProvider);
      router.goNamed(RouterPath.studyEnglish.name);
    });
  }
}
