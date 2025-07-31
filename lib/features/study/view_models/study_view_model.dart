import 'package:machat/features/home/enums/subject_enum.dart';
import 'package:machat/features/study/models/study.dart';
import 'package:machat/features/study/models/subject.dart';
import 'package:machat/features/study/providers/subject_list_length.dart';
import 'package:machat/router/lib.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'study_view_model.g.dart';

@riverpod
class StudyViewModel extends _$StudyViewModel {
  @override
  Future<StudyModel> build() async {
    SubjectList dummySubjectList = await getDummySubjectList();

    // 로딩 후에 화면에 보여줄 list들의 길이 세팅
    setListLength(subjectList: dummySubjectList);

    return StudyModel(subjectList: dummySubjectList);
  }

  void setListLength({required SubjectList subjectList}) {
    // subjectListLengthProvider가 초기화되지 않았을 경우 할당
    if (ref.read(subjectListLengthProvider) == null) {
      ref
          .read(subjectListLengthProvider.notifier)
          .update((state) => subjectList.subjectList.length);
    }
  }

  Future<SubjectList> getDummySubjectList() async {
    await Future.delayed(const Duration(milliseconds: 500));

    List<SubjectModel> subjectList = [];

    final eEnglishModel = SubjectModel(
        title: '초등 영어', progressRate: 0.5, lastVisit: DateTime.now());
    final toeicEnglishModel = SubjectModel(
        title: '토익 영어', progressRate: 0.3, lastVisit: DateTime.now());
    subjectList.add(eEnglishModel);
    subjectList.add(toeicEnglishModel);

    return SubjectList(subjectList: subjectList);
  }

  void goSubjectDetail(SubjectEnum subject) {
    // Navigate to the subject detail page
    // This is a placeholder for the actual navigation logic
    print('Navigating to detail page for subject: $subject');
  }

  Future<void> goEnglishPage() async {
    // 애니메이션 딜레이
    Future.delayed(const Duration(milliseconds: 150), () async {
      final router = ref.read(goRouterProvider);
      router.goNamed(RouterPath.studyEnglish.name);
    });
  }

  void goSubjectManagePage() {
    final router = ref.read(goRouterProvider);
    router.goNamed(RouterPath.subjectManage.name);
  }
}
