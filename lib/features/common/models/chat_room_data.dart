import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:machat/features/common/models/user_data.dart';
import 'package:machat/features/common/utils/date_parser.dart';

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
    @Default([]) List<RoomUserData> membersHistory,
    @Default('') String name,
    @Default(false) bool isMine,
  }) = _ChatRoomData;

  factory ChatRoomData.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomDataFromJson({
        ...json,
        'createdAt': parseDateToString(json['createdAt']),
      });
}
