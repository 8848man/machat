import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/core/models/chat.dart';
import 'package:machat/features/chat/interfaces/i_chat_contents_repository.dart';
import 'package:machat/features/chat/repository/fb_chat_contents_repository.dart';
import 'package:machat/features/chat/repository/lc_chat_contents_repository.dart';
import 'package:machat/storage/services/chat_cache_service.dart';

final chatContentsServiceProvider =
    Provider.family<ChatContentsService, String>((ref, chatRoomId) {
  final fbRepository = ref.read(fbChatContentsRepositoryProvider);
  final lcRepository = ref.read(lcChatContentsRepositoryProvider(chatRoomId));
  return ChatContentsService(fbRepository, lcRepository, ref);
});

class ChatContentsService {
  final IChatContentsRepository fbRepository;
  final IChatContentsRepository lcRepository;
  final Ref ref;

  ChatContentsService(this.fbRepository, this.lcRepository, this.ref);

  Future<List<Map<String, dynamic>>> getInitialChats(String roomId) async {
    // 1. 캐시 먼저
    final cached = await lcRepository.getInitialChats(roomId);
    if (cached.isNotEmpty) return cached;

    // 2. 없으면 Firestore
    final remote = await fbRepository.getInitialChats(roomId);
    ref.read(chatCacheProvider(roomId)).appendMessages(
          remote.map((data) {
            return Chat(
              id: data['id'] ?? '',
              createdBy: data['createdBy'] ?? '',
              createdAt: data['createdAt'] ?? DateTime.now().toString(),
              message: data['message'] ?? '',
              isMine: data['isMine'] ?? false,
              type: data['type'] ?? 'chat',
              imageUrl: data['imageUrl'] ?? '',
              deletedTo: List<String>.from(data['deletedTo'] ?? []),
              isDeletedForEveryone: data['isDeletedForEveryone'] ?? false,
            );
          }).toList(),
        );
    return remote;
  }

  Future<void> deleteChatFromMyself({
    required String roomId,
    required String chatId,
    required String userId,
  }) async {
    // Firestore에서 삭제 처리
    await fbRepository.deleteChatFromMyself(
      roomId: roomId,
      chatId: chatId,
      userId: userId,
    );

    // 로컬 캐시에서도 삭제 처리
    await lcRepository.deleteChatFromMyself(
      roomId: roomId,
      chatId: chatId,
      userId: userId,
    );
  }

  Future<void> deleteChatFromAll({
    required String roomId,
    required String chatId,
  }) async {
    // Firestore에서 삭제 처리
    await fbRepository.deleteChatFromAll(
      roomId: roomId,
      chatId: chatId,
    );

    // 로컬 캐시에서도 삭제 처리
    await lcRepository.deleteChatFromAll(
      roomId: roomId,
      chatId: chatId,
    );
  }
}
