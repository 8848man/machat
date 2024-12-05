import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_model.freezed.dart';

@freezed
class RegisterModel with _$RegisterModel {
  const factory RegisterModel({
    @Default(null) String? nameErrorText,
    @Default(null) String? emailErrorText,
    @Default(null) String? pwdErrorText,
  }) = _RegisterModel;
}
