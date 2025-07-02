import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rwkim_tts/features/tts_service/repositories/supertone_repository.dart';
import 'package:rwkim_tts/features/tts_service/services/tts_service.dart';
// import 'package:rwkim_tts/rwkim_tts.dart';

// final simpleTTSProvider = Provider<SimpleTTS>((ref) {
//   return SimpleTTS(baseUrl: 'https://supertone-api.onrender.com');
// });

// final chatTTSProvider = Provider<TTSServiceImpl>((ref) {
//   // Chat TTS는 별도의 baseUrl을 사용하지 않음
//   return TTSServiceImpl(
//     TTSRepository(
//         baseUrl: 'https://supertone-api.onrender.com', path: '/api/v1/tts'),
//   );
// });

final chatTTSProvider = StateProvider<TTSService>((ref) {
  // Chat TTS는 별도의 baseUrl을 사용하지 않음
  return TTSServiceImpl(
    TTSRepository(
        baseUrl: 'https://supertone-api.onrender.com', path: '/api/v1/tts'),
  );
});
