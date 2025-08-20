import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final audioPlayerProvider = Provider.autoDispose<AudioPlayer>((ref) {
  final player = AudioPlayer();
  ref.onDispose(() {
    player.dispose();
  });
  return player;
});

final positionProvider = StreamProvider.autoDispose<Duration>((ref) {
  final player = ref.watch(audioPlayerProvider);
  return player.onPositionChanged;
});

final durationProvider = StreamProvider.autoDispose<Duration?>((ref) {
  final player = ref.watch(audioPlayerProvider);
  return player.onDurationChanged;
});

final playerStateProvider = StreamProvider.autoDispose<PlayerState>((ref) {
  final player = ref.watch(audioPlayerProvider);
  return player.onPlayerStateChanged;
});

final ttsPlayerProvider =
    ChangeNotifierProvider.autoDispose<TtsPlayerController>((ref) {
  final player = ref.watch(audioPlayerProvider);
  return TtsPlayerController(player);
});

class TtsPlayerController extends ChangeNotifier {
  final AudioPlayer _player;

  PlayerState _state = PlayerState.stopped;
  PlayerState get state => _state;

  TtsPlayerController(this._player) {
    _player.onPlayerStateChanged.listen((s) {
      _state = s;
      notifyListeners();
    });
  }

  Future<void> speak(Uint8List bytes) async {
    await _player.play(BytesSource(bytes));
  }

  Future<void> audioResume() => _player.resume();
  Future<void> audioPause() => _player.pause();
  Future<void> audioStop() => _player.stop();
}
