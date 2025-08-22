import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/extensions.dart';
import 'package:machat/features/chat/features/chat_option_dialog/features/rwkim_tts/view_models/rwkim_tts_view_model.dart';
import 'package:machat/features/chat/features/chat_option_dialog/features/rwkim_tts/view_models/tts_player.dart';

class AudioController extends ConsumerWidget {
  final double? width;
  const AudioController({super.key, this.width});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        const AudioProgressBar().expand(),
        _buildAudioButton(),
      ],
    );
  }
}

class AudioProgressBar extends ConsumerWidget {
  const AudioProgressBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manager = ref.watch(ttsPlayerManagerProvider);

    final positionAsync = ref.watch(ttsPlayerPositionProvider);
    final durationAsync = ref.watch(ttsPlayerDurationProvider);
    final position = positionAsync.value ?? Duration.zero;
    final duration = durationAsync.value ?? Duration.zero;

    return Slider(
      value: position.inMilliseconds.toDouble(),
      max: duration.inMilliseconds.toDouble(),
      onChanged: (value) {
        manager.seek(Duration(milliseconds: value.toInt()));
      },
    );
  }
}

Widget _buildAudioButton() {
  return Consumer(builder: (context, ref, child) {
    final manager = ref.watch(ttsPlayerManagerProvider);

    switch (manager.state) {
      case PlayerState.playing:
        return IconButton(
          icon: const Icon(Icons.pause),
          onPressed: () => manager.audioPause(),
        );
      case PlayerState.paused:
      case PlayerState.stopped:
        return IconButton(
          icon: const Icon(Icons.play_arrow),
          onPressed: () => manager.audioResume(),
        );
      case PlayerState.completed:
        return IconButton(
          icon: const Icon(Icons.play_arrow),
          onPressed: () => manager.audioResume(),
        );
      default:
        return const Icon(Icons.error);
    }
  });
}
