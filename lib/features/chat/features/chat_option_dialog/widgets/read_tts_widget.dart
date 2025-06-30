import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/chat/features/chat_option_dialog/providers/selecting_character_state.dart';
import 'package:machat/features/chat/features/chat_option_dialog/providers/sound_loading_state.dart';
import 'package:machat/features/chat/features/chat_option_dialog/view_models/chat_option_dialog_view_model.dart';
import 'package:machat/features/chat/features/chat_option_dialog/widgets/charactor_row_view.dart';

class ReadTtsTile extends ConsumerStatefulWidget {
  const ReadTtsTile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReadTtsWidgetState();
}

class _ReadTtsWidgetState extends ConsumerState<ReadTtsTile> {
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isChatSoundLoadingProvider);
    final isCharacterSelecting = ref.watch(isSelectingCharacterProvider);
    final notifier = ref.read(chatOptionDialogViewModelProvider.notifier);
    return ListTile(
      leading: _getLeading(isLoading),
      title: _getTitle(isCharacterSelecting),
      onTap: () => notifier.speakChatMessage(),
      trailing: _getTrailing(),
    );
  }

  Widget _getLeading(bool isLoading) {
    return isLoading
        ? const CircularProgressIndicator()
        : const Icon(Icons.speaker_rounded);
  }

  Widget _getTitle(bool isCharacterSelecting) {
    return isCharacterSelecting
        ? const AnimatedHorizontalList()
        : const Text('읽어주기');
  }

  Widget _getTrailing() {
    return GestureDetector(
      onTap: () => ref
          .read(isSelectingCharacterProvider.notifier)
          .update((state) => !state),
      child: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
      ),
    );
  }
}
