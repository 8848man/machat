import 'package:firebase_auth/firebase_auth.dart';
import 'package:machat/features/common/providers/loading_state_provider.dart';
import 'package:machat/features/snack_bar_manager/lib.dart';
import 'package:machat/features/study/features/voca/models/word_model.dart';
import 'package:machat/features/study/features/voca/repositories/voca_repository.dart';
import 'package:machat/features/study/features/voca/services/voca_service.dart';
import 'package:machat/features/study/features/voca/utils/get_pure_english.dart';
import 'package:machat/features/study/features/voca/view_models/memo_list_view_model.dart';
import 'package:machat/features/study/models/vocabulary_model.dart';
import 'package:machat/features/study/providers/voca_info_provider.dart';
import 'package:machat/router/lib.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_voca_view_model.g.dart';

@riverpod
class AddVocaViewModel extends _$AddVocaViewModel {
  @override
  void build() {}

  Future<WordModel?> getWordInFirebase(String wordString) async {
    final String validatedWord = englishValidation(wordString);
    // 입력값 밸리데이션
    if (validatedWord == REQUIRE_NO_ONLY_SPACE) {
      SnackBarCaller().callSnackBar(ref, REQUIRE_NO_ONLY_SPACE);
      return null;
    }
    if (validatedWord == REQUIRE_ENGLISH_ONLY) {
      SnackBarCaller().callSnackBar(ref, REQUIRE_ENGLISH_ONLY);
      return null;
    }

    try {
      final repo = ref.read(vocaRepositoryProvider);
      final WordModel? getWord = await repo.getWord(validatedWord);

      return getWord;
    } catch (e) {
      print('getWord error! $e');

      SnackBarCaller().callSnackBar(ref, '해당 단어는 사전에 없어요!');
      rethrow;
    }
  }

  Future<void> registerWord(WordModel wordData) async {
    try {
      ref.read(loadingStateProvider.notifier).update((state) => true);
      // loadingState
      final VocaService vService = ref.read(vocaServiceProvider);
      final VocabularyModel nowVocabulary = ref.read(nowVocaProvider);
      final User? nowUser = FirebaseAuth.instance.currentUser;
      if (nowUser == null) {
        return;
      }
      final nowUserId = nowUser.uid;

      await vService.saveToUserVocabulary(
        word: wordData,
        vocabData: nowVocabulary,
        userId: nowUserId,
      );

      // 이전 페이지 단어 리스트 초기화
      ref.invalidate(memoListViewModelProvider);
      ref.read(goRouterProvider).pop();
    } catch (e) {
      print('registerWord failed! error : $e');
    } finally {
      ref.read(loadingStateProvider.notifier).update((state) => false);
    }
  }
}
