import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:machat/features/study/features/voca/models/word_model.dart';

part 'memo_list_model.freezed.dart';
part 'memo_list_model.g.dart';

@freezed
class MemoListModel with _$MemoListModel {
  const factory MemoListModel({
    @Default([]) List<WordModel> wordList,
  }) = _MemoListModel;

  factory MemoListModel.fromJson(Map<String, dynamic> json) =>
      _$MemoListModelFromJson(json);
}
