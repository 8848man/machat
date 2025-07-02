import 'package:audioplayers/audioplayers.dart';
import 'package:rwkim_tts/features/tts_service/repositories/supertone_repository.dart';
import 'package:rwkim_tts/features/tts_service/services/tts_service.dart';

class MCTTSServiceImpl implements TTSService {
  final TTSRepository repository;

  late final AudioPlayer _player; // late -> nullable로 변경

  MCTTSServiceImpl(this.repository);

  @override
  Future<void> init() async {
    _player = AudioPlayer();
  }

  @override
  Future<void> speak(Map<String, dynamic> data) async {
    try {
      final audioBytes = await repository.fetchTtsAudio(data);
      await _player.play(BytesSource(audioBytes));
    } catch (e) {
      print('TTSServiceImpl speak error: $e');
      return;
    }
  }

  @override
  Future<void> stop() async {
    await _player.stop();
  }

  @override
  Future<void> dispose() async {
    _player.dispose();
  }
}
