import 'package:freezed_annotation/freezed_annotation.dart';

part 'subject.freezed.dart';

@freezed
class SubjectList with _$SubjectList {
  const factory SubjectList({
    @Default([]) List<SubjectModel> subjectList,
  }) = _SubjectList;
}

@freezed
class SubjectModel with _$SubjectModel {
  const factory SubjectModel({
    @Default('') String title,
    @Default(0) double progressRate,
    DateTime? lastVisit,
  }) = _SubjectModel;

  factory SubjectModel.initial() => SubjectModel(
        lastVisit: DateTime.now(),
      );
}
