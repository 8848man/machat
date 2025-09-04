import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_vocabulary_model.freezed.dart';

@freezed
class AddVocabularyModel with _$AddVocabularyModel {
  const factory AddVocabularyModel({
    required bool isLoading,
  }) = _AddVocabularyModel;
}
