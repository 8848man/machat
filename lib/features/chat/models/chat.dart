import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat.freezed.dart';
part 'chat.g.dart';

// @freezed
// class Chat with _$Chat {
//   const factory Chat({
//     required String id,
//     required String message,
//     required String createdBy,
//     required String createdAt,
//     @Default(false) bool isMine,
//     @Default('chat') String type,
//     String? imageUrl,
//     List<String>? deletedTo,
//     @Default(false) bool isDeletedForEveryone,
//     @Default('')
//     String lastDoc, // This can be a DocumentSnapshot or a timestamp
//   }) = _Chat;

//   factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
// }

@freezed
class Chat with _$Chat {
  const factory Chat({
    required String id,
    required String message,
    required String createdBy,
    required String createdAt, // ✅ Timestamp → DateTime
    @Default(false) bool isMine,
    @Default('chat') String type,
    String? imageUrl,
    @Default([]) List<String> deletedTo,
    @Default(false) bool isDeletedForEveryone,
  }) = _Chat;

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json['id'] ?? '',
        message: json['message'] ?? '',
        createdBy: json['createdBy'] ?? '',
        createdAt: json['createdAt'] ?? '',
        isMine: json['isMine'] ?? false,
        type: json['type'] ?? 'chat',
        imageUrl: json['imageUrl'],
        deletedTo: (json['deletedTo'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        isDeletedForEveryone: json['isDeletedForEveryone'] ?? false,
      );
  factory Chat.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Chat.fromJson({
      ...data,
      'id': doc.id,
    });
  }
}

class ChatFetchResult {
  final List<Chat> chats;
  final DocumentSnapshot? lastDoc;

  ChatFetchResult({required this.chats, required this.lastDoc});
}
