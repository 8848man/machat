import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_create_model.freezed.dart';

@freezed
class ChatCreateModel with _$ChatCreateModel {
  const factory ChatCreateModel({
    @Default(null) String? roomNameErrorText,
  }) = _ChatCreateModel;
}
