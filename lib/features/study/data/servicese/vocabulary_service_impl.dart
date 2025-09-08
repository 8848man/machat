import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/study/domain/services/vocabulary_service.dart';
import 'package:machat/networks/firestore_provider.dart';

final vocabularyServiceProvider = Provider<VocabularyService>((ref) {
  final FirebaseFirestore firestore = ref.read(firestoreProvider);
  return VocabularyServiceImpl(firestore);
});

class VocabularyServiceImpl implements VocabularyService {
  final FirebaseFirestore _firestore;

  VocabularyServiceImpl(this._firestore);

  @override
  Future<void> earnPoints({
    required String userId,
    required String vocabularyId,
    required int score,
  }) async {
    late int currentTokens;
    late int totalEarnedTokens;
    final tokenRef = _firestore.collection('token').doc(userId);
    final tokenLogRef = _firestore.collection('token_log').doc();
    final vocabRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('user_vocabulary')
        .doc(vocabularyId);

    final tokenSnapshot = await tokenRef.get();

    currentTokens =
        tokenSnapshot.exists ? tokenSnapshot.data()!['currentTokens'] ?? 0 : 0;
    totalEarnedTokens = tokenSnapshot.exists
        ? tokenSnapshot.data()!['totalEarnedTokens'] ?? 0
        : 0;

    try {
      await _firestore.runTransaction((transaction) async {
        // 1️⃣ Vocabulary 단어장 업데이트
        transaction.update(vocabRef, {'hasEarnPoints': true});

        // 3️⃣ Token 문서 업데이트 (merge로 안전하게)
        transaction.set(
          tokenRef,
          {
            'currentTokens': currentTokens + score,
            'totalEarnedTokens': totalEarnedTokens + score,
            'updatedAt': DateTime.now(),
          },
          SetOptions(merge: true),
        );

        // 4️⃣ Token 로그 기록
        final logData = {
          'amount': score,
          'balanceBefore': currentTokens,
          'balanceAfter': currentTokens + score,
          'createdAt': FieldValue.serverTimestamp(),
          'description': 'Vocabulary Earned',
          'metadata': null,
          'type': 'earn',
          'userId': userId,
        };
        transaction.set(tokenLogRef, logData);
      });
    } catch (e, stack) {
      print('Error during earnPoints transaction: $e');
      print(stack);
    }
  }
}
