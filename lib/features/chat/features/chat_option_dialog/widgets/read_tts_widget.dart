import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/config/voice_package_config.dart';
import 'package:machat/features/chat/features/chat_option_dialog/providers/now_character_provider.dart';
import 'package:machat/features/chat/features/chat_option_dialog/providers/selecting_character_state.dart';
import 'package:machat/features/chat/features/chat_option_dialog/providers/sound_loading_state.dart';
import 'package:machat/features/chat/features/chat_option_dialog/view_models/chat_option_dialog_view_model.dart';
import 'package:machat/features/chat/features/chat_option_dialog/widgets/character_list_row.dart';
import 'package:rwkim_tts/features/tts_service/enums/lib.dart';

class ReadTtsTile extends ConsumerStatefulWidget {
  const ReadTtsTile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReadTtsWidgetState();
}

class _ReadTtsWidgetState extends ConsumerState<ReadTtsTile> {
  @override
  Widget build(BuildContext context) {
    final bool isLoading = ref.watch(isChatSoundLoadingProvider);
    final bool isCharacterSelecting = ref.watch(isSelectingCharacterProvider);
    ref.watch(chatOptionDialogViewModelProvider);
    final ChatOptionDialogViewModel notifier =
        ref.read(chatOptionDialogViewModelProvider.notifier);
    final VoiceCharacter nowCharacter = ref.watch(nowCharacterProvider);
    return ListTile(
      leading: _getLeading(isLoading),
      title: _getTitle(isCharacterSelecting),
      onTap: () => notifier.speakChatMessage(),
      trailing: _getTrailing(nowCharacter),
    );
  }

  Widget _getLeading(bool isLoading) {
    return isLoading
        ? const CircularProgressIndicator()
        : const Icon(Icons.speaker_rounded);
  }

  Widget _getTitle(bool isCharacterSelecting) {
    return isCharacterSelecting ? const CharacterListRow() : const Text('읽어주기');
  }

  Widget _getTrailing(VoiceCharacter character) {
    return GestureDetector(
      onTap: () => ref
          .read(isSelectingCharacterProvider.notifier)
          .update((state) => !state),
      child: SizedBox(
        height: 30,
        width: 30,
        child: CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(
            getVoiceImagePath(character,
                packageName: ttsPackageName), // 캐릭터 이미지 경로
          ), // Replace with your character image
        ),
      ),
    );
  }
}
