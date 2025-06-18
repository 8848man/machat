import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter/foundation.dart';

class VoiceService {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  bool _isListening = false;
  String _lastWords = '';

  // 음성 인식 초기화
  Future<bool> initializeSpeech() async {
    try {
      await _speechToText.initialize();
      return true;
    } catch (e) {
      debugPrint('음성 인식 초기화 실패: $e');
      return false;
    }
  }

  // 음성 인식 시작
  Future<void> startListening(Function(String) onResult) async {
    if (!_isListening) {
      _isListening = true;
      await _speechToText.listen(
        onResult: (result) {
          _lastWords = result.recognizedWords;
          onResult(_lastWords);
        },
        localeId: 'ko_KR', // 한국어 설정
      );
    }
  }

  // 음성 인식 중지
  Future<void> stopListening() async {
    if (_isListening) {
      _isListening = false;
      await _speechToText.stop();
    }
  }

  // TTS 초기화
  Future<void> initializeTts() async {
    await _flutterTts.setLanguage('ko-KR');
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  // 텍스트를 음성으로 변환
  Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }

  // TTS 중지
  Future<void> stopSpeaking() async {
    await _flutterTts.stop();
  }

  // 현재 음성 인식 상태
  bool get isListening => _isListening;

  // 마지막으로 인식된 텍스트
  String get lastWords => _lastWords;
} 