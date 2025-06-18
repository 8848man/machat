import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'voice_provider.dart';

class VoiceWidget extends ConsumerStatefulWidget {
  const VoiceWidget({super.key});

  @override
  ConsumerState<VoiceWidget> createState() => _VoiceWidgetState();
}

class _VoiceWidgetState extends ConsumerState<VoiceWidget> {
  @override
  void initState() {
    super.initState();
    // 음성 서비스 초기화
    Future.microtask(() => ref.read(voiceStateProvider.notifier).initialize());
  }

  @override
  Widget build(BuildContext context) {
    final voiceState = ref.watch(voiceStateProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 음성 인식 상태 표시
        Text(
          voiceState.isListening ? '음성 인식 중...' : '음성 인식 대기 중',
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 20),
        
        // 인식된 텍스트 표시
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            voiceState.recognizedText.isEmpty
                ? '인식된 텍스트가 여기에 표시됩니다.'
                : voiceState.recognizedText,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 20),
        
        // 음성 인식 버튼
        ElevatedButton(
          onPressed: voiceState.isListening
              ? () => ref.read(voiceStateProvider.notifier).stopListening()
              : () => ref.read(voiceStateProvider.notifier).startListening(),
          child: Text(voiceState.isListening ? '음성 인식 중지' : '음성 인식 시작'),
        ),
        const SizedBox(height: 10),
        
        // TTS 버튼
        ElevatedButton(
          onPressed: voiceState.recognizedText.isEmpty
              ? null
              : () => ref.read(voiceStateProvider.notifier).speak(voiceState.recognizedText),
          child: const Text('텍스트를 음성으로 변환'),
        ),
      ],
    );
  }
} 