import 'package:firebase_auth/firebase_auth.dart';
import 'package:machat/features/home/enums/subject_enum.dart';
import 'package:machat/features/snack_bar_manager/lib.dart';
import 'package:machat/features/study/data/models/study.dart';
import 'package:machat/features/study/data/models/vocabulary_model.dart';
import 'package:machat/features/study/data/usecases/earn_point_use_case_impl.dart';
import 'package:machat/features/study/presentation/providers/subject_list_length.dart';
import 'package:machat/features/study/presentation/providers/voca_info_provider.dart';
import 'package:machat/features/study/data/repositories/vocabulary_repository_impl.dart';
import 'package:machat/router/lib.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'study_view_model.g.dart';

@riverpod
class StudyViewModel extends _$StudyViewModel {
  @override
  Future<StudyModel> build() async {
    VocabularyModelList vocabList = await getVocabList();

    setVocabListLength(vocabList: vocabList);

    return StudyModel(vocabularyModelList: vocabList);
  }

  void setVocabListLength({required VocabularyModelList vocabList}) {
    ref
        .read(vocabularyListLengthProvider.notifier)
        .update((state) => vocabList.vocabularyList.length);
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

      final orderedVocabList = vocabList.toList()
        ..sort((a, b) {
          final aLastVisit =
              a.lastVisit ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bLastVisit =
              b.lastVisit ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bLastVisit.compareTo(aLastVisit);
        });

      return VocabularyModelList(vocabularyList: orderedVocabList);
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

  Future<void> goEnglishVocaPage(VocabularyModel vocabData) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      Exception('유저 정보가 없습니다!');
    }
    ref.read(vocabularyRepositoryProvider).setVocabularyLastVisit(
        userId: currentUser!.uid,
        vocabularyId: vocabData.id ?? '',
        lastVisit: DateTime.now());
    // 애니메이션 딜레이
    Future.delayed(const Duration(milliseconds: 150), () async {
      // 현재 Voca 데이터 갱신
      ref.read(nowVocaProvider.notifier).update((state) => vocabData);
      // 라우팅
      final router = ref.read(goRouterProvider);
      router.goNamed(RouterPath.englishVoca.name);
    });
  }

  void goSubjectManagePage() {
    final router = ref.read(goRouterProvider);
    router.goNamed(RouterPath.subjectManage.name);
  }

  void deleteVocabulary(VocabularyModel vocabData) {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        Exception('유저 정보가 없습니다!');
      }
      ref
          .read(vocabularyRepositoryProvider)
          .deleteVocabulary(
              userId: currentUser!.uid, vocabularyId: vocabData.id ?? '')
          .then((_) {
        // 삭제 성공 시, SnackBar 표시
        SnackBarCaller().callSnackBar(ref, '단어장이 삭제되었습니다.');
        // 단어장 리스트 갱신
        update((state) async {
          VocabularyModelList updatedVocabList = await getVocabList();
          setVocabListLength(vocabList: updatedVocabList);
          return state.copyWith(vocabularyModelList: updatedVocabList);
        });
      }).catchError((error) {
        // 삭제 실패 시, SnackBar 표시
        SnackBarCaller().callSnackBar(ref, '단어장 삭제에 실패했습니다. $error');
      });
    } catch (e) {
      SnackBarCaller().callSnackBar(ref, '단어장 삭제에 실패했습니다. $e');
      return;
    }
  }

  Future<void> earnPoints(VocabularyModel vocabData) async {
    try {
      if (vocabData.hasEarnPoints) {
        SnackBarCaller().callSnackBar(ref, '이미 포인트를 얻었어요!');
        return;
      }
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        Exception('유저 정보가 없습니다!');
      }
      await ref
          .read(earnPointsUseCaseProvider)
          .call(
              userId: currentUser!.uid,
              vocabularyId: vocabData.id ?? '',
              score: vocabData.wordCount)
          .then((_) {
        // 성공 시, SnackBar 표시
        SnackBarCaller().callSnackBar(ref, '포인트를 얻었어요!');
        // 단어장 리스트 갱신
        update((state) async {
          VocabularyModelList updatedVocabList = await getVocabList();
          setVocabListLength(vocabList: updatedVocabList);
          return state.copyWith(vocabularyModelList: updatedVocabList);
        });
      }).catchError((error) {
        // 실패 시, SnackBar 표시
        SnackBarCaller().callSnackBar(ref, '포인트 획득에 실패했습니다. $error');
      });
    } catch (e) {
      SnackBarCaller().callSnackBar(ref, '포인트 획득에 실패했습니다. $e');
      return;
    }
  }
}
