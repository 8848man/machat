// 이미지 채팅과 텍스트 채팅을 하나로 병합하는 StreamProvider
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/chat/repository/chat_contents_repository.dart';
import 'package:machat/features/common/providers/chat_room_id.dart';

final mergedChatStreamProvider =
    StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  final roomId = ref.watch(chatRoomIdProvider);
  final repo = ref.watch(chatContentsRepositoryProvider);
  final entryTime = DateTime.now();
  // return repo.getMergedChatStream(roomId);
  return repo.subscribeToNewChats(roomId, entryTime);
});
