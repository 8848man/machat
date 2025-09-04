import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat.freezed.dart';
part 'chat.g.dart';

@freezed
class Chat with _$Chat {
  const factory Chat({
    @Default('') String id,
    @Default('') String message,
    @Default('') String createdBy,
    @Default('') String createdAt,
    @Default(false) bool isMine,
    @Default('chat') String type,
    @Default('') String imageUrl,
    @Default([]) List<String> deletedTo,
    @Default(false) bool isDeletedForEveryone,
  }) = _Chat;

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
}
