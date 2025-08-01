import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:machat/features/study/models/vocabulary_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final vocabularyRepositoryProvider = Provider<VocabularyRepository>((ref) {
  final firestore = FirebaseFirestore.instance;
  return VocabularyRepository(firestore);
});

class VocabularyRepository {
  final FirebaseFirestore _firestore;

  VocabularyRepository(this._firestore);

  Future<void> saveVocabularyTransaction({
    required String userId,
    required VocabularyModel vocabulary,
  }) async {
    try {
      await _firestore.runTransaction((transaction) async {
        await _saveToUserVocabulary(transaction, userId, vocabulary);

        await _saveToPublicVocabulary(transaction, vocabulary);
      });
    } catch (e) {
      print('Error occurred during transaction: $e');
    }
  }

  Future<void> _saveToUserVocabulary(
    Transaction transaction,
    String userId,
    VocabularyModel vocabulary,
  ) async {
    final userVocaRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('user_vocabulary')
        .doc(vocabulary.id);

    transaction.set(userVocaRef, vocabulary.toJson());
  }

  Future<void> _saveToPublicVocabulary(
    Transaction transaction,
    VocabularyModel vocabulary,
  ) async {
    final publicVocaRef =
        _firestore.collection('vocabulary').doc(vocabulary.id);

    transaction.set(publicVocaRef, vocabulary.toJson());
  }

  Future<List<VocabularyModel>> fetchUserVocabulariesOrderedByLastVisit(
      String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('user_vocabulary')
        .orderBy('lastVisit', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => VocabularyModel.fromJson(doc.data()..['id'] = doc.id))
        .toList();
  }
}
