import 'package:flutter_test/flutter_test.dart';
import 'package:machat/voice/voice_service.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

// Mock 클래스 생성
@GenerateMocks([SpeechToText, FlutterTts])
import 'voice_service_test.mocks.dart';

void main() {
  late VoiceService voiceService;
  late MockSpeechToText mockSpeechToText;
  late MockFlutterTts mockFlutterTts;

  setUp(() {
    mockSpeechToText = MockSpeechToText();
    mockFlutterTts = MockFlutterTts();
    voiceService = VoiceService();
  });

  group('VoiceService Tests', () {
    test('initializeSpeech - 성공 케이스', () async {
      // Given
      when(mockSpeechToText.initialize()).thenAnswer((_) async => true);

      // When
      final result = await voiceService.initializeSpeech();

      // Then
      expect(result, true);
      verify(mockSpeechToText.initialize()).called(1);
    });

    test('initializeSpeech - 실패 케이스', () async {
      // Given
      when(mockSpeechToText.initialize()).thenThrow(Exception('초기화 실패'));

      // When
      final result = await voiceService.initializeSpeech();

      // Then
      expect(result, false);
    });

    test('startListening - 음성 인식 시작', () async {
      // Given
      String capturedText = '';
      when(mockSpeechToText.listen(
        onResult: anyNamed('onResult'),
        localeId: 'ko_KR',
      )).thenAnswer((_) async {});

      // When
      await voiceService.startListening((text) {
        capturedText = text;
      });

      // Then
      expect(voiceService.isListening, true);
      verify(mockSpeechToText.listen(
        onResult: anyNamed('onResult'),
        localeId: 'ko_KR',
      )).called(1);
    });

    test('stopListening - 음성 인식 중지', () async {
      // Given
      when(mockSpeechToText.stop()).thenAnswer((_) async {});

      // When
      await voiceService.stopListening();

      // Then
      expect(voiceService.isListening, false);
      verify(mockSpeechToText.stop()).called(1);
    });

    test('initializeTts - TTS 초기화', () async {
      // Given
      when(mockFlutterTts.setLanguage('ko-KR')).thenAnswer((_) async => 1);
      when(mockFlutterTts.setSpeechRate(0.5)).thenAnswer((_) async => 1);
      when(mockFlutterTts.setVolume(1.0)).thenAnswer((_) async => 1);
      when(mockFlutterTts.setPitch(1.0)).thenAnswer((_) async => 1);

      // When
      await voiceService.initializeTts();

      // Then
      verify(mockFlutterTts.setLanguage('ko-KR')).called(1);
      verify(mockFlutterTts.setSpeechRate(0.5)).called(1);
      verify(mockFlutterTts.setVolume(1.0)).called(1);
      verify(mockFlutterTts.setPitch(1.0)).called(1);
    });

    test('speak - 텍스트를 음성으로 변환', () async {
      // Given
      const testText = '테스트 텍스트';
      when(mockFlutterTts.speak(testText)).thenAnswer((_) async => 1);

      // When
      await voiceService.speak(testText);

      // Then
      verify(mockFlutterTts.speak(testText)).called(1);
    });

    test('stopSpeaking - TTS 중지', () async {
      // Given
      when(mockFlutterTts.stop()).thenAnswer((_) async => 1);

      // When
      await voiceService.stopSpeaking();

      // Then
      verify(mockFlutterTts.stop()).called(1);
    });
  });
} 