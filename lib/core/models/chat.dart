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

  // ✅ Map → Chat
  // factory Chat.fromMap(Map<String, dynamic> map) {
  //   return Chat(
  //     id: map['id'] as String? ?? '',
  //     createdBy: map['createdBy'] as String? ?? '',
  //     createdAt: map['createdAt']
  //         ? map['createdAt']
  //         : map['createdAt'].toString(),
  //     message: map['message'] as String? ?? '',
  //     isMine: map['isMine'] as bool? ?? false,
  //     type: map['type'] as String? ?? 'chat',
  //     imageUrl: map['imageUrl'] as String? ?? '',
  //     deletedTo: (map['deletedTo'] as List<dynamic>?)
  //             ?.map((e) => e.toString())
  //             .toList() ??
  //         [],
  //     isDeletedForEveryone: map['isDeletedForEveryone'] as bool? ?? false,
  //   );
  // }

  // // ✅ Chat → Map (반대로도 활용 가능)
  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     'createdBy': createdBy,
  //     'createdAt': createdAt,
  //     'message': message,
  //     'isMine': isMine,
  //     'type': type,
  //     'imageUrl': imageUrl,
  //     'deletedTo': deletedTo,
  //     'isDeletedForEveryone': isDeletedForEveryone,
  //   };
  // }
}

extension ChatMapper on Chat {
  static Chat fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'] as String? ?? '',
      message: map['message'] as String? ?? '',
      createdBy: map['createdBy'] as String? ?? '',
      createdAt: map['createdAt'] as String,
      isMine: map['isMine'] as bool? ?? false,
      type: map['type'] as String? ?? 'chat',
      imageUrl: map['imageUrl'] as String? ?? '',
      deletedTo:
          (map['deletedTo'] as List?)?.map((e) => e.toString()).toList() ??
              const [],
      isDeletedForEveryone: map['isDeletedForEveryone'] as bool? ?? false,
    );
  }
}
