import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/chat/features/chat_option_dialog/features/rwkim_tts/interfaces/tts_cache_repository.dart';
import 'package:machat/features/chat/features/chat_option_dialog/features/rwkim_tts/models/tts_cache_model.dart';
import 'package:machat/features/chat/features/chat_option_dialog/features/rwkim_tts/repository/tts_cache_repository.dart';

// === 5. Provider 선언 ===
final ttsCacheProvider =
    NotifierProvider<TtsCacheNotifier, Map<TtsCacheKey, Uint8List>>(
  TtsCacheNotifier.new,
);

// === 4. Notifier 정의 ===
class TtsCacheNotifier extends Notifier<Map<TtsCacheKey, Uint8List>> {
  late final TtsCacheRepository _repository;

  @override
  Map<TtsCacheKey, Uint8List> build() {
    _repository = InMemoryTtsCacheRepository(); // 추후 LocalDB/Hive/Isar 교체 가능
    return {};
  }

  Uint8List? get(TtsCacheKey key) {
    return _repository.get(key);
  }

  void put(TtsCacheKey key, Uint8List value) {
    _repository.put(key, value);
    state = {...state, key: value};
  }

  void delete(TtsCacheKey key) {
    _repository.delete(key);
    final newState = {...state}..remove(key);
    state = newState;
  }
}
