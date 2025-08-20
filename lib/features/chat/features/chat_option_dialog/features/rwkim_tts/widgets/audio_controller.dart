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
    final position = ref.watch(positionProvider).value ?? Duration.zero;
    final duration = ref.watch(durationProvider).value ?? Duration.zero;

    return Slider(
      value: position.inMilliseconds.toDouble(),
      max: duration.inMilliseconds.toDouble(),
      onChanged: (value) {
        ref
            .read(audioPlayerProvider)
            .seek(Duration(milliseconds: value.toInt()));
      },
    );
  }
}

Widget _buildAudioButton() {
  return Consumer(builder: (context, ref, child) {
    final playerState = ref.watch(playerStateProvider);
    print('웹에서 해당 audioPlayer 사용시 UnimplementedError 발생. 기능적 문제는 없음');
    return playerState.when(
      data: (state) {
        if (state == PlayerState.playing) {
          return IconButton(
            icon: const Icon(Icons.pause),
            onPressed: () => ref.read(audioPlayerProvider).pause(),
          );
        } else {
          return IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () => ref.read(audioPlayerProvider).resume(),
          );
        }
      },
      loading: () => IconButton(
        icon: const Icon(Icons.play_arrow),
        onPressed: () =>
            ref.read(rwkimTtsViewmodelProvider.notifier).getAudioData(),
      ),
      error: (_, __) => const Icon(Icons.error),
    );
  });
}
