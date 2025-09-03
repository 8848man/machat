import 'package:freezed_annotation/freezed_annotation.dart';

part 'storage_chat.freezed.dart';
part 'storage_chat.g.dart';

@freezed
class StorageChat with _$StorageChat {
  const factory StorageChat({
    @Default('') String id,
    @Default('') String message,
    @Default('') String createdBy,
    @Default('') String createdAt,
    @Default(false) bool isMine,
    @Default('chat') String type,
    @Default('') String imageUrl,
    @Default([]) List<String> deletedTo,
    @Default(false) bool isDeletedForEveryone,
  }) = _StorageChat;

  factory StorageChat.fromJson(Map<String, dynamic> json) =>
      _$StorageChatFromJson(json);
}
