import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/voice/voice_provider.dart';
import 'package:machat/voice/voice_service.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([VoiceService])
import 'voice_provider_test.mocks.dart';

void main() {
  late ProviderContainer container;
  late MockVoiceService mockVoiceService;

  setUp(() {
    mockVoiceService = MockVoiceService();
    container = ProviderContainer(
      overrides: [
        voiceServiceProvider.overrideWithValue(mockVoiceService),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('VoiceStateNotifier Tests', () {
    test('initialize - 음성 서비스 초기화', () async {
      // Given
      when(mockVoiceService.initializeSpeech()).thenAnswer((_) async => true);
      when(mockVoiceService.initializeTts()).thenAnswer((_) async {});

      // When
      await container.read(voiceStateProvider.notifier).initialize();

      // Then
      verify(mockVoiceService.initializeSpeech()).called(1);
      verify(mockVoiceService.initializeTts()).called(1);
    });

    test('startListening - 음성 인식 시작', () async {
      // Given
      when(mockVoiceService.startListening(any)).thenAnswer((_) async {});

      // When
      await container.read(voiceStateProvider.notifier).startListening();

      // Then
      verify(mockVoiceService.startListening(any)).called(1);
      expect(container.read(voiceStateProvider).isListening, true);
    });

    test('stopListening - 음성 인식 중지', () async {
      // Given
      when(mockVoiceService.stopListening()).thenAnswer((_) async {});

      // When
      await container.read(voiceStateProvider.notifier).stopListening();

      // Then
      verify(mockVoiceService.stopListening()).called(1);
      expect(container.read(voiceStateProvider).isListening, false);
    });

    test('speak - 텍스트를 음성으로 변환', () async {
      // Given
      const testText = '테스트 텍스트';
      when(mockVoiceService.speak(testText)).thenAnswer((_) async {});

      // When
      await container.read(voiceStateProvider.notifier).speak(testText);

      // Then
      verify(mockVoiceService.speak(testText)).called(1);
      expect(container.read(voiceStateProvider).isSpeaking, false);
    });

    test('stopSpeaking - TTS 중지', () async {
      // Given
      when(mockVoiceService.stopSpeaking()).thenAnswer((_) async {});

      // When
      await container.read(voiceStateProvider.notifier).stopSpeaking();

      // Then
      verify(mockVoiceService.stopSpeaking()).called(1);
      expect(container.read(voiceStateProvider).isSpeaking, false);
    });

    test('상태 업데이트 - 음성 인식 결과', () async {
      // Given
      const testText = '인식된 텍스트';
      when(mockVoiceService.startListening(any)).thenAnswer((invocation) async {
        final callback = invocation.namedArguments[const Symbol('onResult')] as Function(String);
        callback(testText);
      });

      // When
      await container.read(voiceStateProvider.notifier).startListening();

      // Then
      expect(container.read(voiceStateProvider).recognizedText, testText);
    });
  });
} 