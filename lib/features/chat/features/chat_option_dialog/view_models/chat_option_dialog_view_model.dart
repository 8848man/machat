import 'package:machat/features/chat/features/chat_option_dialog/providers/sound_loading_state.dart';
import 'package:machat/features/chat/providers/chat_dialog_state_provider.dart';
import 'package:machat/features/chat/providers/chat_tts_provider.dart';
import 'package:machat/features/snack_bar_manager/lib.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:rwkim_tts/simple_tts.dart';
import 'package:rwkim_tts/rwkim_tts.dart';
part 'chat_option_dialog_view_model.g.dart';

@riverpod
class ChatOptionDialogViewModel extends _$ChatOptionDialogViewModel {
  late final SimpleTTS _tts;
  @override
  bool build() {
    _tts = ref.watch(simpleTTSProvider);
    // 캐릭터 선택 상태 초기화
    ref.read(chatDialogValueProvider.notifier).update((state) => false);
    ref.onDispose(() {
      _tts.dispose();
    });
    return false;
  }

  Future<void> speakChatMessage() async {
    // 다이얼로그에 진입할 때 저장된 채팅 밸류 가져오기
    final chatValue = ref.read(chatDialogValueProvider);
    // 음성 로딩 상태 변경
    ref.read(isChatSoundLoadingProvider.notifier).update((state) => true);

    try {
      await _tts.speakText(
        text: chatValue['message'],
        voiceId: 'c9858bccab131431a5c3c7',
        language: 'ko',
      );
    } catch (e) {
      print('TTS Error: $e');
      SnackBarCaller().callSnackBar(ref, '음성 재생 중 에러가 발생했습니다.');
    } finally {
      // 음성 로딩 상태 초기화
      ref.read(isChatSoundLoadingProvider.notifier).update((state) => false);
    }
  }
}
