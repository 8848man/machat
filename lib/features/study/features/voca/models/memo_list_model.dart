import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'word_model.dart';

part 'memo_list_model.freezed.dart';
part 'memo_list_model.g.dart';

@freezed
class MemoListModel with _$MemoListModel {
  const factory MemoListModel({
    @Default([]) List<WordModel> wordList,
    @JsonKey(ignore: true) DocumentSnapshot? lastDoc, // <- ignore
    dynamic lastSortValue, // lastDoc이 직렬화가 필요하면 여기에 저장 (optional)
    @Default(true) bool hasMore,
  }) = _MemoListModel;

  factory MemoListModel.fromJson(Map<String, dynamic> json) =>
      _$MemoListModelFromJson(json);
}
