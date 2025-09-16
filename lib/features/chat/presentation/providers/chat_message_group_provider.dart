// 이미지 채팅과 텍스트 채팅을 하나로 병합하는 StreamProvider
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/core/models/chat.dart';
import 'package:machat/features/chat/data/repository/fb_chat_contents_repository.dart';
import 'package:machat/features/common/providers/chat_room_id.dart';
import 'package:machat/storage/wrapper/chat_service_wrapper.dart';

final mergedChatStreamProvider =
    StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  final roomId = ref.watch(chatRoomIdProvider);
  final repo = ref.watch(fbChatContentsRepositoryProvider);
  final entryTime = DateTime.now();
  // return repo.getMergedChatStream(roomId);
  return repo.subscribeToNewChats(roomId, entryTime).map((chats) {
    if (chats.isNotEmpty) {
      final lastChat = chats.last;
      final savingChat = Chat.fromJson(lastChat);
      ref
          .read(chatServiceWrapperProvider(roomId))
          .safeAppendMessages([savingChat]);
    }
    return chats;
  });
});
