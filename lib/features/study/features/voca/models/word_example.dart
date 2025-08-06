import 'package:freezed_annotation/freezed_annotation.dart';

part 'word_example.freezed.dart';
part 'word_example.g.dart';

@freezed
class WordExample with _$WordExample {
  const factory WordExample({
    required String type, // 예: 'en', 'ko', 'definition', 'usage'
    required String value,
    String? source, // optional: 예문 출처
    @Default(false) bool isGeneratedByAI,
  }) = _WordExample;

  factory WordExample.fromJson(Map<String, dynamic> json) =>
      _$WordExampleFromJson(json);
}
