import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/core/models/chat.dart';
import 'package:machat/features/chat/interfaces/i_chat_contents_repository.dart';
import 'package:machat/storage/services/chat_cache_service.dart';

final lcChatContentsRepositoryProvider =
    Provider.family<LcChatContentsRepository, String>((ref, chatRoomId) {
  final storage = ref.read(chatCacheProvider(chatRoomId));
  return LcChatContentsRepository(cacheService: storage);
});

class LcChatContentsRepository extends IChatContentsRepository {
  final ChatCacheService _cacheService;

  LcChatContentsRepository({required ChatCacheService cacheService})
      : _cacheService = cacheService;

  @override
  Future<List<Map<String, dynamic>>> getInitialChats(String roomId) async {
    // 로컬 캐시에서 불러오기
    final messages = _cacheService.messages;

    return messages.map((chat) {
      return {
        'id': chat.id,
        'createdBy': chat.createdBy,
        'createdAt': chat.createdAt,
        'message': chat.message,
        'isMine': chat.isMine,
        'type': chat.type,
        'imageUrl': chat.imageUrl,
        'deletedTo': chat.deletedTo,
        'isDeletedForEveryone': chat.isDeletedForEveryone,
      };
    }).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getPreviousChats({
    required String roomId,
    required DateTime lastCreatedAt,
  }) async {
    // fetchPreviousMessages 메소드 사용
    // final prevMessages = await _cacheService.fetchPreviousMessages(
    //   (lastMsg) async {
    //     // 로컬 캐시에서는 더 이상 서버 호출 없이 빈 리스트 반환
    //     return [];
    //   },
    //   limit: 30,
    // );

    // // lastCreatedAt 기준 필터링
    // final filtered = prevMessages
    //     .where((chat) => chat.createdAt.isBefore(lastCreatedAt))
    //     .toList();

    // return filtered.map((chat) {
    //   return {
    //     'id': chat.id,
    //     'createdBy': chat.createdBy,
    //     'createdAt': chat.createdAt,
    //     'message': chat.message,
    //     'isMine': chat.isMine,
    //     'type': chat.type,
    //     'imageUrl': chat.imageUrl,
    //     'deletedTo': chat.deletedTo,
    //     'isDeletedForEveryone': chat.isDeletedForEveryone,
    //   };
    // }).toList();
    return []; // 로컬 캐시에서는 이전 메시지 기능 구현 X
  }

  @override
  Future<void> deleteChatFromMyself({
    required String roomId,
    required String chatId,
    required String userId,
  }) async {
    final updated = _cacheService.messages.map((chat) {
      if (chat.id == chatId && chat.deletedTo.contains(userId) == false) {
        return chat.copyWith(deletedTo: [...chat.deletedTo, userId]);
      }
      return chat;
    }).toList();

    await _cacheService.appendMessages(updated); // 저장
  }

  @override
  Future<void> deleteChatFromAll({
    required String roomId,
    required String chatId,
  }) async {
    final updated = _cacheService.messages.map((chat) {
      if (chat.id == chatId) {
        return chat.copyWith(isDeletedForEveryone: true);
      }
      return chat;
    }).toList();

    await _cacheService.appendMessages(updated); // 저장
  }

  Future<void> saveChatData(List<Map<String, dynamic>> data) async {
    try {
      final List<Chat> chatList =
          data.map((map) => ChatMapper.fromMap(map)).toList();
      await _cacheService.appendMessages(chatList);
    } catch (e) {
      print('error Occured Saving Chat data : $e');
    }
  }
}
