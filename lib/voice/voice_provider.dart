import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'voice_service.dart';

final voiceServiceProvider = Provider<VoiceService>((ref) {
  return VoiceService();
});

final voiceStateProvider = StateNotifierProvider<VoiceStateNotifier, VoiceState>((ref) {
  final voiceService = ref.watch(voiceServiceProvider);
  return VoiceStateNotifier(voiceService);
});

class VoiceState {
  final bool isListening;
  final String recognizedText;
  final bool isSpeaking;

  VoiceState({
    this.isListening = false,
    this.recognizedText = '',
    this.isSpeaking = false,
  });

  VoiceState copyWith({
    bool? isListening,
    String? recognizedText,
    bool? isSpeaking,
  }) {
    return VoiceState(
      isListening: isListening ?? this.isListening,
      recognizedText: recognizedText ?? this.recognizedText,
      isSpeaking: isSpeaking ?? this.isSpeaking,
    );
  }
}

class VoiceStateNotifier extends StateNotifier<VoiceState> {
  final VoiceService _voiceService;

  VoiceStateNotifier(this._voiceService) : super(VoiceState());

  Future<void> initialize() async {
    await _voiceService.initializeSpeech();
    await _voiceService.initializeTts();
  }

  Future<void> startListening() async {
    await _voiceService.startListening((text) {
      state = state.copyWith(
        recognizedText: text,
      );
    });
    state = state.copyWith(isListening: true);
  }

  Future<void> stopListening() async {
    await _voiceService.stopListening();
    state = state.copyWith(isListening: false);
  }

  Future<void> speak(String text) async {
    state = state.copyWith(isSpeaking: true);
    await _voiceService.speak(text);
    state = state.copyWith(isSpeaking: false);
  }

  Future<void> stopSpeaking() async {
    await _voiceService.stopSpeaking();
    state = state.copyWith(isSpeaking: false);
  }
} 