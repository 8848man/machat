import 'package:freezed_annotation/freezed_annotation.dart';
part 'vocabulary_model.freezed.dart';
part 'vocabulary_model.g.dart';

@freezed
class VocabularyModelList with _$VocabularyModelList {
  const factory VocabularyModelList({
    @Default([]) List<VocabularyModel> vocabularyList,
  }) = _VocabularyModelList;

  factory VocabularyModelList.fromJson(Map<String, dynamic> json) =>
      _$VocabularyModelListFromJson(json);
}

@freezed
class VocabularyModel with _$VocabularyModel {
  const VocabularyModel._(); // ← 커스텀 getter 사용 시 필요!
  const factory VocabularyModel({
    String? id,
    @Default('') String userId,
    @Default(0) int wordCount,
    @Default(0) int memorizedWordCount,
    @Default(0) int confusedWordCount,
    @Default([]) List<String> tags,
    int? sortIndex,
    @Default('') String title,
    @Default('') String memo,
    DateTime? createdDate,
    DateTime? modifiedDate,
    DateTime? deletedDate,
    DateTime? lastVisit,
  }) = _VocabularyModel;

  factory VocabularyModel.fromJson(Map<String, dynamic> json) =>
      _$VocabularyModelFromJson(json);

  // Computed getter
  double get progressRate => wordCount > 0 ? memorizedWordCount / wordCount : 0;

  double get progressConfusedRate =>
      wordCount > 0 ? confusedWordCount / wordCount : 0;
}
