import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:machat/features/common/models/user_data.dart';

part 'add_friend.freezed.dart';
part 'add_friend.g.dart';

@freezed
class AddFriendModel with _$AddFriendModel {
  const factory AddFriendModel({
    required List<UserData> users,
  }) = _AddFriendModel;

  factory AddFriendModel.fromJson(Map<String, dynamic> json) =>
      _$AddFriendModelFromJson(json);
}
