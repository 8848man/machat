import 'package:firebase_auth/firebase_auth.dart';
import 'package:machat/features/study/features/voca/models/memo_list_model.dart';
import 'package:machat/features/study/features/voca/models/word_model.dart';
import 'package:machat/features/study/features/voca/repositories/voca_repository.dart';
import 'package:machat/features/study/models/vocabulary_model.dart';
import 'package:machat/features/study/providers/voca_info_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'memo_list_view_model.g.dart';

@riverpod
class MemoListViewModel extends _$MemoListViewModel {
  @override
  Future<MemoListModel> build() async {
    final VocabularyModel nowVocabulary = ref.watch(nowVocaProvider);
    final MemoListModel data = await getData(nowVocabulary.id ?? '');

    return data;
  }

  Future<MemoListModel> getData(String vocabId) async {
    final repo = ref.read(vocaRepositoryProvider);
    final currentUser = FirebaseAuth.instance.currentUser;

    try {
      final String userId = currentUser?.uid ?? '';

      final List<WordModel> data =
          await repo.getWordList(userId: userId, vocabId: vocabId);

      return MemoListModel(wordList: data);
    } catch (e) {
      rethrow;
    }
  }
}
