import 'package:freezed_annotation/freezed_annotation.dart';

part 'word_model.freezed.dart';
part 'word_model.g.dart';

@freezed
class WordModel with _$WordModel {
  const factory WordModel({
    @Default('') String id,
    @Default('') String word,
    @Default('') String meaning,
    String? partOfSpeech,
    @Default([]) List<String> examples,
    String? pronunciation,
    @Default([]) List<String> tags,
    @Default(false) bool isGeneratedByAI,
    double? confidenceScore,
    bool? isManuallyReviewed,
    @Default(null) DateTime? createdAt,
    @Default(null) DateTime? updatedAt,
  }) = _WordModel;

  factory WordModel.fromJson(Map<String, dynamic> json) =>
      _$WordModelFromJson(json);
}
