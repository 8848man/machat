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
    String? pronunciation,
    @Default(false) bool isGeneratedByAI,
    bool? isManuallyReviewed,
    DateTime? createdAt,
    DateTime? updatedAt,
    @JsonKey(name: 'example_sentence') String? exampleSentence,
    @JsonKey(name: 'example_translation') String? exampleTranslation,
    @JsonKey(name: 'confidence_score') double? confidenceScore,
    @JsonKey(name: 'part_of_speech') String? partOfSpeech,
    @JsonKey(fromJson: _masteryFromJson, toJson: _masteryToJson)
    @Default(WordMasteryLevel.unknown)
    WordMasteryLevel masteryLevel,
  }) = _WordModel;

  factory WordModel.fromJson(Map<String, dynamic> json) =>
      _$WordModelFromJson(json);
}

// enum <-> String 변환
WordMasteryLevel _masteryFromJson(String? value) => WordMasteryLevel.values
    .firstWhere((e) => e.name == value, orElse: () => WordMasteryLevel.unknown);

String _masteryToJson(WordMasteryLevel level) => level.name;

@JsonEnum(alwaysCreate: true)
enum WordMasteryLevel {
  unknown('외우지 않음'),
  confused('헷갈림'),
  mastered('외움');

  const WordMasteryLevel(this.value);
  final String value;
}
