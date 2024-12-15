import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_room_data.freezed.dart';
part 'chat_room_data.g.dart';

@freezed
class ChatRoomData with _$ChatRoomData {
  const factory ChatRoomData({
    @Default('') String roomId,
    @Default('') String createdBy,
    String? createdAt,
    @Default([]) List<String> members,
    @Default('') String name,
    @Default(false) bool isMine,
  }) = _ChatRoomData;

  factory ChatRoomData.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomDataFromJson(json);
}
