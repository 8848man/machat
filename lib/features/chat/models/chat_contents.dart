import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:machat/features/common/models/chat_room_data.dart';

part 'chat_contents.freezed.dart';
// part 'chat_contents.g.dart';

@freezed
class ChatContentsModel with _$ChatContentsModel {
  const factory ChatContentsModel({
    required List<dynamic> contents,
    required bool isLoading,
    required bool hasMore,
    required DocumentSnapshot? lastDoc,
    required ChatRoomData roomData,
  }) = _ChatContentsModel;

  // factory ChatContentsModel.fromJson(Map<String, dynamic> json) =>
  //     _$ChatContentsModelFromJson({...json, 'lastDocId': json['lastDoc']});
}
