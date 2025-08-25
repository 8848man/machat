// === 3. InMemory Repository 기본 구현 ===
import 'dart:typed_data';

import 'package:machat/features/chat/features/chat_option_dialog/features/rwkim_tts/interfaces/tts_cache_repository.dart';
import 'package:machat/features/chat/features/chat_option_dialog/features/rwkim_tts/models/tts_cache_model.dart';

class InMemoryTtsCacheRepository implements TtsCacheRepository {
  final Map<TtsCacheKey, Uint8List> _store = {};

  @override
  Uint8List? get(TtsCacheKey key) => _store[key];

  @override
  void put(TtsCacheKey key, Uint8List value) {
    _store[key] = value;
  }

  @override
  void delete(TtsCacheKey key) {
    _store.remove(key);
  }

  Map<TtsCacheKey, Uint8List> get all => Map.unmodifiable(_store);
}
