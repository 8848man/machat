import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:machat/features/common/models/user_data.dart';

part 'chat_room_data.freezed.dart';
part 'chat_room_data.g.dart';

// @freezed
// class ChatRoomListData with _$ChatRoomListData {
//   const factory ChatRoomListData({
//     required List<ChatRoomData> roomList,
//   }) = _ChatRoomListData;
// }

@freezed
class ChatRoomData with _$ChatRoomData {
  const factory ChatRoomData({
    @Default('') String roomId,
    @Default('') String createdBy,
    String? createdAt,
    @Default([]) List<String> members,
    @Default([]) List<UserData> membersHistory,
    @Default('') String name,
    @Default(false) bool isMine,
  }) = _ChatRoomData;

  factory ChatRoomData.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomDataFromJson({
        ...json,
        'createdAt': parseCreatedAt(json['createdAt']),
      });

  // createdAt 필드를 파싱하는 메서드
  static String? parseCreatedAt(dynamic createdAt) {
    if (createdAt == null) {
      return null;
    } else if (createdAt is Timestamp) {
      // Firebase Timestamp인 경우
      return createdAt.toDate().toString();
    } else if (createdAt is String) {
      // ISO 8601 문자열인 경우
      return DateTime.parse(createdAt).toString();
    } else {
      throw UnsupportedError('Unsupported createdAt format');
    }
  }
}
