import 'package:freezed_annotation/freezed_annotation.dart';
part 'vocabulary_model.freezed.dart';

@freezed
class VocabularyModel with _$VocabularyModel {
  const factory VocabularyModel({
    String? id,
    @Default('') String userId,
    @Default(false) bool isPublic,
    @Default([]) List<String> sharedUserIds,
    @Default(0) int wordCount,
    @Default([]) List<String> tags,
    int? sortIndex,
    @Default('') String title,
    @Default('') String memo,
    DateTime? createdDate,
    DateTime? modifiedDate,
    DateTime? deletedDate,
    DateTime? lastVisit,
  }) = _VocabularyModel;
}
