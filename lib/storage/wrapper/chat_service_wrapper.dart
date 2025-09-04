import 'package:machat/core/models/chat.dart';
import 'package:machat/storage/services/chat_cache_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final chatServiceWrapperProvider =
    Provider.family<ChatServiceWrapper, String>((ref, chatRoomId) {
  final cacheService = ref.watch(chatCacheProvider(chatRoomId));
  return ChatServiceWrapper(cacheService);
});

class ChatServiceWrapper {
  final ChatCacheService _service;

  ChatServiceWrapper(this._service);

  Future<List<Chat>> safeFetchPreviousMessages(
    Future<List<Chat>> Function(Chat lastMessage) fetchFromServer, {
    int limit = 30,
  }) async {
    try {
      final result = await _service.fetchPreviousMessages(
        fetchFromServer: fetchFromServer,
        limit: limit,
      );

      // 후처리: 정렬
      return result..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      // 공통 에러 처리
      print("Error fetching previous messages: $e");
      return [];
    }
  }

  Future<void> safeAppendMessages(List<Chat> newMessages) async {
    try {
      await _service.appendMessages(newMessages);
    } catch (e) {
      print("Error appending messages: $e");
    }
  }

  Future<void> safeHandleNewMessage(Chat newMessage) async {
    try {
      await _service.handleNewMessage(newMessage);
    } catch (e) {
      print("Error handling new message: $e");
    }
  }

  List<Chat> get messages => _service.messages;
}
