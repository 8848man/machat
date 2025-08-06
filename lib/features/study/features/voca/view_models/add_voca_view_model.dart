import 'package:firebase_auth/firebase_auth.dart';
import 'package:machat/features/study/features/voca/models/word_model.dart';
import 'package:machat/features/study/features/voca/repositories/voca_repository.dart';
import 'package:machat/features/study/features/voca/services/voca_service.dart';
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
    final repo = ref.read(vocaRepositoryProvider);
    final WordModel? getWord = await repo.getWord(wordString);

    return getWord;
  }

  Future<void> registerWord(WordModel wordData) async {
    try {
      final VocaService vService = ref.read(vocaServiceProvider);
      final VocabularyModel nowVocabulary = ref.read(nowVocaProvider);
      final User? nowUser = FirebaseAuth.instance.currentUser;
      if (nowUser == null) {
        return;
      }
      final nowUserId = nowUser.uid;

      await vService.registerWord(
        word: wordData,
        vocabData: nowVocabulary,
        userId: nowUserId,
      );

      ref.read(goRouterProvider).pop();
    } catch (e) {
      print('registerWord failed! error : $e');
    }
  }
}
