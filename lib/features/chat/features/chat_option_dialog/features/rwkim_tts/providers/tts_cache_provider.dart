import 'dart:typed_data';

import 'package:machat/features/chat/features/chat_option_dialog/features/rwkim_tts/models/tts_cache_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final ttsCacheProvider = Provider<Map<TtsCacheKey, Uint8List>>((ref) {
  return {};
});
