import 'package:firebase_auth/firebase_auth.dart';
import 'package:machat/features/snack_bar_manager/lib.dart';
import 'package:machat/features/study/features/add_vocabulary/models/add_vocabulary_model.dart';
import 'package:machat/features/study/models/vocabulary_model.dart';
import 'package:machat/features/study/repositories/vocabulary_repository.dart';
import 'package:machat/features/study/view_models/study_view_model.dart';
import 'package:machat/router/lib.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_vocabulary_view_model.g.dart';

@riverpod
class AddVocabularyViewModel extends _$AddVocabularyViewModel {
  @override
  AddVocabularyModel build() {
    return initialState;
  }

  AddVocabularyModel get initialState =>
      const AddVocabularyModel(isLoading: false);

  Future<void> saveVocabulary({
    required String title,
    required String memo,
  }) async {
    final repository = ref.read(vocabularyRepositoryProvider);
    try {
      // loading 상태일 경우 그냥 리턴
      if (state.isLoading) return;
      setLoading(true);
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('유저 정보가 없습니다.');
      }
      final VocabularyModel vocabulary = VocabularyModel(
        userId: currentUser.uid,
        title: title,
        memo: memo,
        createdDate: DateTime.now(),
        // 정렬 기본값 설정
        lastVisit: DateTime.now(),
      );
      await repository.saveVocabularyTransaction(
          userId: currentUser.uid, vocabulary: vocabulary);

      // 데이터를 들고있던 프로바이더를 dispose
      ref.invalidate(studyViewModelProvider);
      final router = ref.read(goRouterProvider);

      router.pop();
    } catch (e) {
      print('$e');
      SnackBarCaller().callSnackBar(ref, '단어장을 저장하는데 실패했습니다! 에러 코드 : $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> setLoading(bool isLoading) async {
    state = state.copyWith(isLoading: isLoading);
  }
}
