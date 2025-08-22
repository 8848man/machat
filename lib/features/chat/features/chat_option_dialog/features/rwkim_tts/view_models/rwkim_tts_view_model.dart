import 'package:machat/features/chat/features/chat_option_dialog/features/rwkim_tts/models/tts_cache_model.dart';
import 'package:machat/features/chat/features/chat_option_dialog/features/rwkim_tts/providers/now_character_provider.dart';
import 'package:machat/features/chat/features/chat_option_dialog/features/rwkim_tts/providers/selecting_character_state.dart';
import 'package:machat/features/chat/features/chat_option_dialog/features/rwkim_tts/providers/sound_loading_state.dart';
import 'package:machat/features/chat/features/chat_option_dialog/features/rwkim_tts/providers/tts_cache_provider.dart';
import 'package:machat/features/chat/features/chat_option_dialog/features/rwkim_tts/repository/tts_repository.dart';
import 'package:machat/features/chat/features/chat_option_dialog/features/rwkim_tts/view_models/tts_player.dart';
import 'package:machat/features/chat/providers/chat_dialog_state_provider.dart';
import 'package:machat/features/snack_bar_manager/lib.dart';
import 'package:machat_token_service/features/token/lib.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rwkim_tts/features/tts_service/enums/lib.dart';
import 'package:rwkim_tts/features/tts_service/repositories/supertone_repository.dart';
// import 'package:rwkim_tts/simple_tts.dart';
part 'rwkim_tts_view_model.g.dart';

@riverpod
class RwkimTtsViewmodel extends _$RwkimTtsViewmodel {
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

  Future<void> getAudioData() async {
    // 다이얼로그에 진입할 때 저장된 채팅 밸류 가져오기
    final chatValue = ref.read(chatDialogValueProvider);
    final chatCacheProvider = ref.read(ttsCacheProvider.notifier);

    final VoiceCharacter nowCharacter = ref.read(nowCharacterProvider);
    final String message = chatValue['message'];

    try {
      final cacheKey = TtsCacheKey(
        messageId: chatValue['id'],
        voiceCharacter: nowCharacter.id,
      );
      print('test005, cacheKey is $cacheKey');
      final cachedData = chatCacheProvider.get(cacheKey);

      if (cachedData != null) {
        // 캐시된 데이터가 있으면 바로 재생
        print('test001, play cachedData!');
        ref.read(ttsPlayerManagerProvider).speak(cachedData);
        return;
      }

      // 메세지 길이 제한
      if (message.length >= 50) {
        SnackBarCaller().callSnackBar(ref, '메세지가 너무 길어요! 50자 이내 메세지를 선택해주세요');
        return;
      }
      ref.read(isChatSoundLoadingProvider.notifier).update((state) => true);
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

      final TTSRepository repository = ref.read(ttsRepositoryProvider);
      final bytes = await repository.fetchTtsAudio({
        'text': message,
        'voiceId': nowCharacter.id,
        'language': 'ko',
      });
      final player = ref.read(ttsPlayerManagerProvider);

      player.speak(bytes);

      chatCacheProvider.put(
        TtsCacheKey(
          messageId: chatValue['id'],
          voiceCharacter: nowCharacter.id,
        ),
        bytes,
      );
      await tokenNotifier.spendTokens(10, description: 'TTS 기능 사용');
    } catch (e) {
      SnackBarCaller().callSnackBar(ref, '음성 재생 중 에러가 발생했습니다.');
    } finally {
      // 음성 로딩 상태 초기화
      ref.read(isChatSoundLoadingProvider.notifier).update((state) => false);
    }
  }
}
