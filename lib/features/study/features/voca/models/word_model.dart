import 'package:freezed_annotation/freezed_annotation.dart';

part 'word_model.freezed.dart';
part 'word_model.g.dart';

@freezed
class WordModel with _$WordModel {
  const factory WordModel({
    required String id,
    required String word,
    required String meaning,
    String? partOfSpeech,
    List<String>? examples,
    String? pronunciation,
    List<String>? tags,
    @Default(false) bool isGeneratedByAI,
    double? confidenceScore,
    bool? isManuallyReviewed,
    @Default(null) DateTime? createdAt,
    @Default(null) DateTime? updatedAt,
  }) = _WordModel;

  factory WordModel.fromJson(Map<String, dynamic> json) =>
      _$WordModelFromJson(json);
}
