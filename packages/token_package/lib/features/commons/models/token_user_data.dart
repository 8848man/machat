import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_user_data.freezed.dart';
part 'token_user_data.g.dart';

@freezed
class TokenUserData with _$TokenUserData {
  const factory TokenUserData({
    required String name,
    String? id,
    String? email,
    String? profileUrl,
    String? nationId,
    String? role,
  }) = _TokenUserData;

  factory TokenUserData.fromJson(Map<String, dynamic> json) =>
      _$TokenUserDataFromJson(json);
}
