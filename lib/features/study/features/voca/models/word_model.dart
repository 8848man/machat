import 'package:freezed_annotation/freezed_annotation.dart';

part 'word_model.freezed.dart';
part 'word_model.g.dart';

@freezed
class WordModel with _$WordModel {
  const factory WordModel({
    @Default('') String id,
    @Default('') String word,
    @Default([]) List<String> meanings,
    @Default('') String level,
    @Default([]) List<String> tags,
    @Default([]) List<String> synonyms,
    @Default([]) List<String> antonyms,
    @JsonKey(name: 'example_sentence') String? exampleSentence,
    @JsonKey(name: 'example_translation') String? exampleTranslation,
    @JsonKey(name: 'confidence_score') double? confidenceScore,
    String? pronunciation,
    @JsonKey(name: 'part_of_speech') String? partOfSpeech,
    @Default(false) bool isGeneratedByAI,
    bool? isManuallyReviewed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _WordModel;

  factory WordModel.fromJson(Map<String, dynamic> json) =>
      _$WordModelFromJson(json);
}
