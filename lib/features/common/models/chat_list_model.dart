import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:machat/features/common/models/chat_room_data.dart';

part 'chat_list_model.freezed.dart';

@freezed
class ChatListModel with _$ChatListModel {
  const factory ChatListModel({
    @Default([]) List<ChatRoomData> roomList,
  }) = _ChatListModel;
}
