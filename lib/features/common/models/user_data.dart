import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:machat/features/common/utils/date_parser.dart';

part 'user_data.freezed.dart';
part 'user_data.g.dart';

@freezed
class UserData with _$UserData {
  const factory UserData({
    required String name,
    String? id,
    String? email,
    String? profileUrl,
    String? nationId,
  }) = _UserData;

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}

@freezed
class RoomUserData with _$RoomUserData {
  const factory RoomUserData({
    required String name,
    String? id,
    String? email,
    String? profileUrl,
    String? nationId,
    String? lastJoinedAt,
  }) = _RoomUserData;

  factory RoomUserData.fromJson(Map<String, dynamic> json) =>
      _$RoomUserDataFromJson({
        ...json,
        'lastJoinedAt': parseDateToString(json['lastJoinedAt']),
      });
}

extension RoomUserDataX on RoomUserData {
  UserData toUserData() => UserData(
        name: name,
        id: id,
        email: email,
        profileUrl: profileUrl,
        nationId: nationId,
      );
}

extension UserDataX on UserData {
  RoomUserData toRoomUserData() => RoomUserData(
        name: name,
        id: id,
        email: email,
        profileUrl: profileUrl,
        nationId: nationId,
      );
}
