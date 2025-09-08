import 'package:machat/features/study/data/models/vocabulary_model.dart';

abstract class VocabularyRepository {
  Future<void> saveVocabularyTransaction({
    required String userId,
    required VocabularyModel vocabulary,
  });

  Future<List<VocabularyModel>> fetchUserVocabulariesOrderedByLastVisit(
    String userId,
  );

  Future<void> deleteVocabulary({
    required String userId,
    required String vocabularyId,
  });

  Future<void> setVocabularyLastVisit({
    required String userId,
    required String vocabularyId,
    required DateTime lastVisit,
  });
}
