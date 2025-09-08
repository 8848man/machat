abstract class EarnPointsUseCase {
  /// vocabData.id, user.id 기반으로 점수 지급
  Future<void> call({
    required String userId,
    required String vocabularyId,
    required int score,
  });
}
