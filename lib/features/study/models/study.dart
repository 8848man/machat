import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:machat/features/study/models/vocabulary_model.dart';

part 'study.freezed.dart';

@freezed
class StudyModel with _$StudyModel {
  const factory StudyModel({
    VocabularyModelList? vocabularyModelList,
  }) = _StudyModel;
}
