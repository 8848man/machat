abstract class VocabularyService {
  Future<void> earnPoints(
      {required String userId,
      required String vocabularyId,
      required int score}) async {}
}
