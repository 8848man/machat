import 'package:firebase_auth/firebase_auth.dart';
import 'package:machat/features/home/enums/subject_enum.dart';
import 'package:machat/features/snack_bar_manager/lib.dart';
import 'package:machat/features/study/models/study.dart';
import 'package:machat/features/study/models/vocabulary_model.dart';
import 'package:machat/features/study/providers/subject_list_length.dart';
import 'package:machat/features/study/providers/voca_info_provider.dart';
import 'package:machat/features/study/repositories/vocabulary_repository.dart';
import 'package:machat/router/lib.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'study_view_model.g.dart';

@riverpod
class StudyViewModel extends _$StudyViewModel {
  @override
  Future<StudyModel> build() async {
    // VocabularyModelList dummyVocabularyList = await getDummyVocabularyList();
    VocabularyModelList dummyVocabularyList = await getVocabList();

    setVocabListLength(vocabList: dummyVocabularyList);

    return StudyModel(vocabularyModelList: dummyVocabularyList);
  }

  void setVocabListLength({required VocabularyModelList vocabList}) {
    // subjectListLengthProvider가 초기화되지 않았을 경우 할당
    if (ref.read(vocabularyListLengthProvider) == null) {
      ref
          .read(vocabularyListLengthProvider.notifier)
          .update((state) => vocabList.vocabularyList.length);
    }
  }

  Future<VocabularyModelList> getDummyVocabularyList() async {
    await Future.delayed(const Duration(milliseconds: 500));
    List<VocabularyModel> vocabList = [];

    final eEnglishModel =
        VocabularyModel(title: '초등 영어', lastVisit: DateTime.now());
    final toeicEnglishModel = VocabularyModel(
        title: '토익 영어',
        lastVisit: DateTime.now(),
        wordCount: 10,
        memorizedWordCount: 5);

    vocabList.add(eEnglishModel);
    vocabList.add(toeicEnglishModel);

    return VocabularyModelList(vocabularyList: vocabList);
  }

  Future<VocabularyModelList> getVocabList() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        Exception('유저 정보가 없습니다!');
      }
      final vocabList = await ref
          .read(vocabularyRepositoryProvider)
          .fetchUserVocabulariesOrderedByLastVisit(currentUser!.uid);

      return VocabularyModelList(vocabularyList: vocabList);
    } catch (e) {
      SnackBarCaller().callSnackBar(ref, '데이터를 가져오는데 실패했습니다. $e');
      rethrow;
    }
  }

  void goSubjectDetail(SubjectEnum subject) {
    // Navigate to the subject detail page
    // This is a placeholder for the actual navigation logic
    print('Navigating to detail page for subject: $subject');
  }

  Future<void> goEnglishVocaPage(VocabularyModel vocaData) async {
    // 애니메이션 딜레이
    Future.delayed(const Duration(milliseconds: 150), () async {
      // 현재 Voca 데이터 갱신
      ref.read(nowVocaProvider.notifier).update((state) => vocaData);

      // 라우팅
      final router = ref.read(goRouterProvider);
      router.goNamed(RouterPath.englishVoca.name);
    });
  }

  void goSubjectManagePage() {
    final router = ref.read(goRouterProvider);
    router.goNamed(RouterPath.subjectManage.name);
  }
}
