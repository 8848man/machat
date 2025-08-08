import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/study/features/voca/models/word_model.dart';
import 'package:machat/features/study/models/vocabulary_model.dart';
import 'package:machat/networks/firestore_provider.dart';

final vocaServiceProvider = Provider<VocaService>((ref) {
  final FirebaseFirestore firestore = ref.read(firestoreProvider);
  return VocaService(ref: ref, firestore: firestore);
});

class VocaService {
  final Ref ref;
  final FirebaseFirestore firestore;

  VocaService({required this.ref, required this.firestore});

  // Future<void> registerWord({
  //   required WordModel word,
  //   required VocabularyModel vocabData,
  //   required String userId,
  // }) async {
  //   try {
  //     final querySnapshot = await firestore
  //         .collection('master_voca')
  //         .where('word', isEqualTo: word.word)
  //         .limit(1)
  //         .get();

  //     final isDuplicate = querySnapshot.docs.isNotEmpty;

  //     // 이미 있는 경우 -> 그 문서의 ID 재사용
  //     final docId = isDuplicate
  //         ? querySnapshot.docs.first.id
  //         : firestore.collection('master_voca').doc().id;

  //     // WordModel에 ID 설정
  //     final wordWithId = word.copyWith(id: docId);

  //     // 레퍼런스 구성
  //     final masterRef = firestore.collection('master_voca').doc(docId);
  //     final vocabRef = firestore
  //         .collection('users')
  //         .doc(userId)
  //         .collection('user_vocabulary')
  //         .doc(vocabData.id);

  //     final wordListRef = vocabRef.collection('wordList').doc(docId);
  //     final existingDocSnapshot = await wordListRef.get();

  //     // 이미 등록되어있을 경우, 리턴
  //     if (existingDocSnapshot.exists) {
  //       SnackBarCaller().callSnackBar(ref, '이미 등록되어있는 단어에요!');
  //       return;
  //     }

  //     // 트랜잭션으로 저장
  //     await firestore.runTransaction((transaction) async {
  //       if (!isDuplicate) {
  //         transaction.set(masterRef, wordWithId.toJson());
  //       }
  //       transaction.set(wordListRef, wordWithId.toJson());
  //       transaction.update(vocabRef, {
  //         'wordCount': FieldValue.increment(1),
  //       });
  //     });
  //   } catch (e) {
  //     print('error occured! $e');
  //     rethrow;
  //   }
  // }

  /// 사용자 단어장에 단어 등록
  Future<void> saveToUserVocabulary({
    required String userId,
    required VocabularyModel vocabData,
    required WordModel word,
  }) async {
    final userVocaRef = firestore
        .collection('users')
        .doc(userId)
        .collection('user_vocabulary')
        .doc(vocabData.id)
        .collection('wordList');

    try {
      await userVocaRef.add(word.toJson());
    } catch (e) {
      print('Error saving word to user vocabulary: $e');
      rethrow;
    }
  }
}
