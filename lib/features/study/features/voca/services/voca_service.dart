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

  /// 사용자 단어장에 단어 등록
  // Future<void> saveToUserVocabulary({
  //   required String userId,
  //   required VocabularyModel vocabData,
  //   required WordModel word,
  // }) async {
  //   final userVocaRef = firestore
  //       .collection('users')
  //       .doc(userId)
  //       .collection('user_vocabulary')
  //       .doc(vocabData.id)
  //       .collection('wordList');

  //   try {
  //     await userVocaRef.doc(word.word).set(word.toJson());
  //   } catch (e) {
  //     print('Error saving word to user vocabulary: $e');
  //     rethrow;
  //   }
  // }
  Future<void> saveToUserVocabulary({
    required String userId,
    required VocabularyModel vocabData,
    required WordModel word,
  }) async {
    final wordListRef = firestore
        .collection('users')
        .doc(userId)
        .collection('user_vocabulary')
        .doc(vocabData.id)
        .collection('wordList')
        .doc(word.word);

    final vocabRef = firestore
        .collection('users')
        .doc(userId)
        .collection('user_vocabulary')
        .doc(vocabData.id);

    try {
      await firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(wordListRef);

        // 단어 새로 등록 로직
        if (!snapshot.exists) {
          // 새 단어 추가 + 단어장 wordCount 증가
          transaction.set(wordListRef, word.toJson());
          transaction.update(vocabRef, {
            'wordCount': FieldValue.increment(1),
          });
        }
        // 단어 업데이트 로직
        else {
          // 기존 단어 업데이트 (createdAt 유지, updatedAt만 갱신)
          final existingData = snapshot.data()!;
          final updatedData = word.toJson();

          // createdAt은 기존 값 유지
          if (existingData.containsKey('createdAt')) {
            updatedData['createdAt'] = existingData['createdAt'];
          }

          // updatedAt을 현재 시간으로 갱신
          updatedData['updatedAt'] = DateTime.now().toString();

          transaction.update(wordListRef, updatedData);
        }
      });
    } catch (e) {
      print('Error saving word to user vocabulary: $e');
      rethrow;
    }
  }

  Future<void> deleteFromUserVocabulary({
    required String userId,
    required VocabularyModel vocabData,
    required WordModel word,
  }) async {
    final wordListRef = firestore
        .collection('users')
        .doc(userId)
        .collection('user_vocabulary')
        .doc(vocabData.id)
        .collection('wordList')
        .doc(word.word);

    final vocabRef = firestore
        .collection('users')
        .doc(userId)
        .collection('user_vocabulary')
        .doc(vocabData.id);

    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(wordListRef);
      if (snapshot.exists) {
        final currentWord = WordModel.fromJson(snapshot.data()!);
        transaction.update(vocabRef, {
          // 현재 단어 상태에 따라 count 변동
          if (currentWord.masteryLevel == WordMasteryLevel.confused)
            'confusedWordCount': FieldValue.increment(-1),
          if (currentWord.masteryLevel == WordMasteryLevel.mastered)
            'memorizedWordCount': FieldValue.increment(-1),
          'wordCount': FieldValue.increment(-1),
        });
      }
    });
  }

  Future<void> changeMastery({
    required String userId,
    required VocabularyModel vocabData,
    required WordModel word,
  }) async {
    try {
      final wordListRef = firestore
          .collection('users')
          .doc(userId)
          .collection('user_vocabulary')
          .doc(vocabData.id)
          .collection('wordList')
          .doc(word.word);

      final vocabRef = firestore
          .collection('users')
          .doc(userId)
          .collection('user_vocabulary')
          .doc(vocabData.id);

      await firestore.runTransaction((transaction) async {
        //  현재 단어 데이터 읽기
        final snapshot = await transaction.get(wordListRef);
        if (!snapshot.exists) return; // 단어가 없으면 종료

        final vocabSnapshot = await transaction.get(vocabRef);
        if (!vocabSnapshot.exists) return;

        final currentWord = WordModel.fromJson(snapshot.data()!);

        //  masteryLevel 변경 로직
        WordMasteryLevel newLevel;
        switch (currentWord.masteryLevel) {
          case WordMasteryLevel.unknown:
            newLevel = WordMasteryLevel.confused;
            break;
          case WordMasteryLevel.confused:
            newLevel = WordMasteryLevel.mastered;
            break;
          case WordMasteryLevel.mastered:
            newLevel = WordMasteryLevel.unknown; // 이미 외운 상태
            break;
        }

        //  단어 업데이트
        final updatedWord = currentWord.copyWith(
          masteryLevel: newLevel,
          updatedAt: DateTime.now(),
        );

        transaction.update(wordListRef, updatedWord.toJson());

        final vocabDataMap = vocabSnapshot.data()!;
        int confusedCount = vocabDataMap['confusedWordCount'] ?? 0;
        int memorizedCount = vocabDataMap['memorizedWordCount'] ?? 0;

        // 이전 masteryLevel 기준으로 카운트 감소
        switch (currentWord.masteryLevel) {
          case WordMasteryLevel.unknown:
            // 아무 것도 감소 없음
            break;
          case WordMasteryLevel.confused:
            confusedCount -= 1;
            break;
          case WordMasteryLevel.mastered:
            memorizedCount -= 1;
            break;
        }

        // 새로운 masteryLevel 기준으로 카운트 증가
        switch (newLevel) {
          case WordMasteryLevel.unknown:
            // 증가 없음
            break;
          case WordMasteryLevel.confused:
            confusedCount += 1;
            break;
          case WordMasteryLevel.mastered:
            memorizedCount += 1;
            break;
        }

        print(
            'tset001, newLevel is $newLevel, confused : $confusedCount, memorized : $memorizedCount');
        transaction.update(vocabRef, {
          'confusedWordCount': confusedCount,
          'memorizedWordCount': memorizedCount,
        });
      });
    } catch (e) {
      print('changeMastery error! : $e');
    }
  }
}
