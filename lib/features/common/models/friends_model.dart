import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:machat/features/common/models/user_data.dart';

part 'friends_model.freezed.dart';

@freezed
class FriendsModel with _$FriendsModel {
  const factory FriendsModel({
    @Default(UserData(name: 'guest')) UserData user,
    @Default([]) List<UserData> friends,
  }) = _FriendsModel;
}
