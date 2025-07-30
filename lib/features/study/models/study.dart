import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:machat/features/study/models/subject.dart';

part 'study.freezed.dart';

@freezed
class StudyModel with _$StudyModel {
  const factory StudyModel({
    SubjectList? subjectList,
  }) = _StudyModel;
}
