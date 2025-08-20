import 'package:machat/features/chat/features/chat_option_dialog/features/rwkim_tts/consts/tts_path.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rwkim_tts/features/tts_service/repositories/supertone_repository.dart';

final ttsRepositoryProvider = Provider<TTSRepository>((ref) {
  return TTSRepository(baseUrl: supertoneApiUrl, path: pstTtsPath);
});
