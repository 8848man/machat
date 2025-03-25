import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_data.freezed.dart';
part 'user_data.g.dart';

@freezed
class UserDataList with _$UserDataList {
  const factory UserDataList({
    required List<UserData> userList,
  }) = _UserDataList;

  factory UserDataList.fromJson(Map<String, dynamic> json) =>
      _$UserDataListFromJson(json);
}

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
