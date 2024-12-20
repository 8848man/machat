import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:machat/features/common/models/chat_room_data.dart';
import 'package:machat/features/common/models/user_data.dart';

part 'drawer_model.freezed.dart';

@freezed
class DrawerModel with _$DrawerModel {
  const factory DrawerModel({
    @Default(UserData(name: 'guest')) UserData user,
    @Default([]) List<ChatRoomData> roomList,
  }) = _DrawerModel;
}
