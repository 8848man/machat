// ------------------------
// ChatCacheService
// ------------------------
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/storage/interfaces/i_json_storage.dart';
import 'package:machat/storage/models/storage_chat.dart';
import 'package:machat/storage/providers/chat_storage_provider.dart';

// ------------------------
// Provider
// ------------------------
final chatCacheProvider =
    Provider.family<ChatCacheService, String>((ref, chatRoomId) {
  return ChatCacheService(chatRoomId: chatRoomId, ref: ref);
});

class ChatCacheService {
  final String chatRoomId;
  final Ref ref;

  // 메모리 캐시
  final List<StorageChat> _messages = [];

  // 로컬 저장소
  late final JsonStorageInterface<List<StorageChat>> _storage;

  ChatCacheService({required this.chatRoomId, required this.ref}) {
    _initStorage();
  }

  Future<void> _initStorage() async {
    _storage = ref.read(chatStorageProvider);
    try {
      await _storage.init();
      await _loadFromStorage(); // init 성공시에만 load 호출
    } catch (e) {
      print('Failed to initialize storage for $chatRoomId: $e');
    }
  }

  // 메모리 + DB 로드
  Future<void> _loadFromStorage() async {
    try {
      final cached = await _storage.load(chatRoomId) as List<dynamic>?;
      if (cached != null) {
        _messages.addAll(cached.map((e) => e));
      }
    } catch (e, _) {
      // 로그만 찍고 무시 → 빈 리스트 유지
      print('Failed to load cache for $chatRoomId: $e');
    }
  }

  List<StorageChat> get messages => List.unmodifiable(_messages);

  // 새로운 메시지 추가
  Future<void> appendMessages(List<StorageChat> newMessages) async {
    final beforeLength = _messages.length;

    for (final msg in newMessages) {
      if (!_messages.any((m) => m.id == msg.id)) {
        _messages.add(msg);
      }
    }

    // 새로운 메시지가 추가된 경우에만 저장
    if (_messages.length != beforeLength) {
      await _storage.save(chatRoomId, _messages);
    }
  }

  Future<void> _saveToStorage() async {
    await _storage.save(
      chatRoomId,
      _messages.map((e) => e).toList(),
    );
  }

  // lazy loading: 마지막 메시지 기준 이전 데이터 가져오기
  Future<List<StorageChat>> fetchPreviousMessages({
    required Future<List<StorageChat>> Function(StorageChat lastMessage)
        fetchFromServer,
    int limit = 30,
  }) async {
    if (_messages.isEmpty) {
      // 메모리 캐시에 없으면 DB에서 로드 (이미 _loadFromStorage에서 함)
      if (_messages.isEmpty) {
        return [];
      }
    }

    final lastMessage = _messages.first;

    // 서버에서 가져오기
    final prevMessages = await fetchFromServer(lastMessage);

    if (prevMessages.isNotEmpty) {
      _messages.insertAll(0, prevMessages); // 메모리 앞쪽에 추가
      await _saveToStorage();
    }

    return prevMessages;
  }

  // Stream 실시간 메시지 처리
  Future<void> handleNewMessage(StorageChat newMessage) async {
    if (!_messages.any((e) => e.id == newMessage.id)) {
      _messages.add(newMessage);
      await _saveToStorage();
    }
  }
}
