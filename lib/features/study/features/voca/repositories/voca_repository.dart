import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/study/features/voca/models/word_model.dart';
import 'package:machat/networks/firestore_provider.dart';

final vocaRepositoryProvider = Provider<VocaRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  return VocaRepository(ref: ref, firestore: firestore);
});

class VocaRepository {
  Ref ref;
  FirebaseFirestore firestore;
  VocaRepository({
    required this.ref,
    required this.firestore,
  });

  Future<WordModel?> getWord(String wordText) async {
    final querySnapshot = await firestore
        .collection('master_voca')
        .where('word', isEqualTo: wordText)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) return null;

    final doc = querySnapshot.docs.first;
    final data = doc.data();

    return WordModel.fromJson({
      ...data,
      'id': doc.id, // 문서 ID를 수동으로 넣어줌
    });
  }

  Future<void> saveWordToMasterVoca(WordModel word) async {
    final wordRef = firestore.collection('master_voca').doc(word.id);
    await wordRef.set(word.toJson());
  }

  Future<void> saveWordToVocabulary({
    required String vocabId,
    required WordModel word,
  }) async {
    final vocabWordRef = firestore
        .collection('vocabulary')
        .doc(vocabId)
        .collection('wordList')
        .doc(word.id);
    await vocabWordRef.set(word.toJson());
  }

  Future<List<WordModel>> getWordList({
    required String userId,
    required String vocabId,
  }) async {
    try {
      final querySnapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('user_vocabulary')
          .doc(vocabId)
          .collection('wordList')
          .get();

      // 각 문서를 WordModel로 변환 후 리스트로 반환
      return querySnapshot.docs
          .map((doc) => WordModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('getWordList error! $e');
      rethrow;
    }
  }
}
