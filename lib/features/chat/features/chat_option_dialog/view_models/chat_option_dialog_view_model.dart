import 'package:machat/features/chat/features/chat_option_dialog/providers/now_character_provider.dart';
import 'package:machat/features/chat/features/chat_option_dialog/providers/selecting_character_state.dart';
import 'package:machat/features/chat/features/chat_option_dialog/providers/sound_loading_state.dart';
import 'package:machat/features/chat/providers/chat_dialog_state_provider.dart';
import 'package:machat/features/chat/providers/chat_tts_provider.dart';
import 'package:machat/features/snack_bar_manager/lib.dart';
import 'package:machat_token_service/features/token/lib.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rwkim_tts/features/tts_service/enums/lib.dart';
// import 'package:rwkim_tts/simple_tts.dart';
part 'chat_option_dialog_view_model.g.dart';

@riverpod
class ChatOptionDialogViewModel extends _$ChatOptionDialogViewModel {
  @override
  bool build() {
    return false;
  }

  void changeCharacter(VoiceCharacter character) {
    ref.read(nowCharacterProvider.notifier).update((state) => character);
    ref.read(isSelectingCharacterProvider.notifier).update((state) => false);
    SnackBarCaller().callSnackBar(
      ref,
      '${character.displayName} 캐릭터로 변경되었습니다.',
    );
  }

  Future<void> speakChatMessage() async {
    // 다이얼로그에 진입할 때 저장된 채팅 밸류 가져오기
    final chatValue = ref.read(chatDialogValueProvider);
    // 음성 로딩 상태 변경
    ref.read(isChatSoundLoadingProvider.notifier).update((state) => true);
    final VoiceCharacter nowCharacter = ref.read(nowCharacterProvider);
    final String message = chatValue['message'];

    // 메세지 길이 제한
    if (message.length >= 50) {
      SnackBarCaller().callSnackBar(ref, '메세지가 너무 길어요! 50자 이내 메세지를 선택해주세요');
      return;
    }

    final tokenState = await ref.watch(tokenViewModelProvider.future);
    final tokenNotifier = ref.read(tokenViewModelProvider.notifier);

    if (tokenState.userToken == null ||
        tokenState.userToken!.currentTokens < 10) {
      SnackBarCaller().callSnackBar(
        ref,
        '토큰이 부족합니다. TTS 기능을 사용하려면 10 토큰이 필요합니다.',
      );
      return;
    }
    ;

    try {
      final tts = ref.read(chatTTSProvider);
      await tts.speak({
        'text': message,
        'voiceId': nowCharacter.id,
        'language': 'ko',
      });
      await tokenNotifier.spendTokens(10, description: 'TTS 기능 사용');
    } catch (e) {
      print('TTS Error: $e');
      SnackBarCaller().callSnackBar(ref, '음성 재생 중 에러가 발생했습니다.');
    } finally {
      // 음성 로딩 상태 초기화
      ref.read(isChatSoundLoadingProvider.notifier).update((state) => false);
    }
  }
}
