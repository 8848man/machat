import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/study/data/servicese/vocabulary_service_impl.dart';
import 'package:machat/features/study/domain/services/vocabulary_service.dart';
import 'package:machat/features/study/domain/usecases/earn_point_use_case.dart';

final earnPointsUseCaseProvider = Provider<EarnPointsUseCase>((ref) {
  final vocabularyService = ref.read(vocabularyServiceProvider);
  return EarnPointsUseCaseImpl(vocabularyService);
});

class EarnPointsUseCaseImpl implements EarnPointsUseCase {
  final VocabularyService _vocabularyService;

  EarnPointsUseCaseImpl(this._vocabularyService);

  @override
  Future<void> call({
    required String userId,
    required String vocabularyId,
    required int score,
  }) async {
    await _vocabularyService.earnPoints(
      userId: userId,
      vocabularyId: vocabularyId,
      score: score,
    );
  }
}
