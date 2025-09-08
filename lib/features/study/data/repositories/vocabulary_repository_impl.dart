import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:machat/features/study/data/models/vocabulary_model.dart';
import 'package:machat/features/study/domain/repositories/vocabulary_repository.dart';
import 'package:machat/networks/firestore_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final vocabularyRepositoryProvider = Provider<VocabularyRepository>((ref) {
  final FirebaseFirestore firestore = ref.read(firestoreProvider);
  return VocabularyRepositoryImpl(firestore);
});

class VocabularyRepositoryImpl implements VocabularyRepository {
  final FirebaseFirestore _firestore;

  VocabularyRepositoryImpl(this._firestore);
  @override
  Future<void> saveVocabularyTransaction({
    required String userId,
    required VocabularyModel vocabulary,
  }) async {
    try {
      await _firestore.runTransaction((transaction) async {
        await _saveToUserVocabulary(transaction, userId, vocabulary);
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

  @override
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

  @override
  Future<void> deleteVocabulary(
      {required String userId, required String vocabularyId}) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('user_vocabulary')
          .doc(vocabularyId)
          .delete();
    } catch (e) {
      print('Error deleting vocabulary: $e');
    }
  }

  @override
  Future<void> setVocabularyLastVisit({
    required String userId,
    required String vocabularyId,
    required DateTime lastVisit,
  }) async {
    try {
      final vocabRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('user_vocabulary')
          .doc(vocabularyId);

      await vocabRef.update({'lastVisit': lastVisit});
    } catch (e) {
      print('Error updating last visit: $e');
    }
  }
}
