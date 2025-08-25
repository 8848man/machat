// === 2. Repository 추상화 ===
import 'dart:typed_data';

import 'package:machat/features/chat/features/chat_option_dialog/features/rwkim_tts/models/tts_cache_model.dart';

abstract class TtsCacheRepository {
  Uint8List? get(TtsCacheKey key);
  void put(TtsCacheKey key, Uint8List value);
  void delete(TtsCacheKey key);
}
