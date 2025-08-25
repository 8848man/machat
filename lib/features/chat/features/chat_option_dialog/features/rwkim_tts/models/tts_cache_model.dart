import 'package:freezed_annotation/freezed_annotation.dart';

part 'tts_cache_model.freezed.dart';

@freezed
class TtsCacheKey with _$TtsCacheKey {
  const factory TtsCacheKey({
    String? messageId,
    String? voiceCharacter,
  }) = _TtsCacheKey;
}
