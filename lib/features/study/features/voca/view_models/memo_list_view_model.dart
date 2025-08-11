import 'package:firebase_auth/firebase_auth.dart';
import 'package:machat/features/snack_bar_manager/lib.dart';
import 'package:machat/features/study/features/voca/enums/voca_sorted_by.dart';
import 'package:machat/features/study/features/voca/models/memo_list_model.dart';
import 'package:machat/features/study/features/voca/models/word_model.dart';
import 'package:machat/features/study/features/voca/providers/voca_sorted_by_provider.dart';
import 'package:machat/features/study/features/voca/repositories/voca_repository.dart';
import 'package:machat/features/study/models/vocabulary_model.dart';
import 'package:machat/features/study/providers/voca_info_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'memo_list_view_model.g.dart';

@riverpod
class MemoListViewModel extends _$MemoListViewModel {
  @override
  Future<MemoListModel> build() async {
    ref.watch(vocaSortedByProvider);
    final VocabularyModel nowVocabulary = ref.watch(nowVocaProvider);
    final MemoListModel data = await getWordDatas(nowVocabulary.id ?? '');

    return data;
  }

  Future<MemoListModel> getWordDatas(String vocabId) async {
    final VocaSortedBy vocaSortedBy = ref.read(vocaSortedByProvider);
    final repo = ref.read(vocaRepositoryProvider);
    final currentUser = FirebaseAuth.instance.currentUser;

    try {
      final String userId = currentUser?.uid ?? '';

      final MemoListModel data = await repo.getWordList(
          userId: userId, vocabId: vocabId, sortedBy: vocaSortedBy.value);

      print('test001, sortedList is ${data.hasMore}');

      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchMoreWordDatas() async {
    final bool nowHasMore =
        state.maybeWhen(data: (data) => data.hasMore, orElse: () => false);
    final VocabularyModel nowVocabulary = ref.read(nowVocaProvider);

    if (!nowHasMore) return;
    if (nowVocabulary.id == null) {
      SnackBarCaller().callSnackBar(ref, '단어장을 찾을 수 없어요!');
      return;
    }

    final repo = ref.read(vocaRepositoryProvider);
    final currentUser = FirebaseAuth.instance.currentUser;
    final String userId = currentUser?.uid ?? '';

    final lastDoc = state.maybeWhen(
      data: (data) => data.lastDoc,
      orElse: () => null,
    );

    if (lastDoc == null) return;

    try {
      final MemoListModel moreData = await repo.fetchMoreWord(
        userId: userId,
        vocabId: nowVocabulary.id ?? '',
        lastDoc: lastDoc,
      );

      final updated = state.asData!.value.copyWith(
        wordList: [
          ...state.asData!.value.wordList,
          ...moreData.wordList,
        ],
        lastDoc: moreData.lastDoc,
        hasMore: moreData.hasMore,
      );

      state = AsyncData(updated);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  MemoListModel sortWordsBy(MemoListModel listModel, String sortBy) {
    // 원본 변경 방지를 위해 복사본 사용
    final List<WordModel> sortedList = List<WordModel>.from(listModel.wordList);

    switch (sortBy) {
      case 'createdAt':
        sortedList.sort((a, b) {
          final aTime = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bTime = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bTime.compareTo(aTime); // 최신순
        });
        break;

      case 'word':
        sortedList.sort((a, b) => (a.word ?? '')
            .toLowerCase()
            .compareTo((b.word ?? '').toLowerCase()));
        break;

      // 필요하다면 다른 정렬 기준 추가
      // case 'custom':
      //   sortedList.sort(...);
      //   break;

      default:
        // 기본은 createdAt 기준
        sortedList.sort((a, b) {
          final aTime = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bTime = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bTime.compareTo(aTime);
        });
        break;
    }

    // 정렬된 리스트를 새로운 MemoListModel에 담아서 반환
    return listModel.copyWith(wordList: sortedList);
  }
}
