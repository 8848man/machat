import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_model.freezed.dart';

@freezed
class LoginModel with _$LoginModel {
  const factory LoginModel({
    @Default(null) String? emailErrorText,
    @Default(null) String? pwdErrorText,
  }) = _LoginModel;
}
