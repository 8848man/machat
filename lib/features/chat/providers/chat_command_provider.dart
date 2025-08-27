import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/chat/models/chat_command.dart';
import 'package:machat/features/chat/utils/command_setter.dart';
import 'package:machat/features/common/models/ai_model.dart';
import 'package:machat/features/common/providers/ai_character_provider.dart';

final chatCommandsProvider =
    StateNotifierProvider<ChatCommandsNotifier, List<ChatCommand>>(
  (ref) => ChatCommandsNotifier(ref),
);

class ChatCommandsNotifier extends StateNotifier<List<ChatCommand>> {
  final Ref ref;

  ChatCommandsNotifier(this.ref) : super([]) {
    _init();
  }

  void _init() {
    ref.listen<AsyncValue<AiModelPage>>(aiCharactersProvider, (prev, next) {
      next.whenOrNull(
        data: (data) {
          state = [
            ...CommandUtils.fixedCommands(),
            ...CommandUtils.fromAiCharacters(data.models),
          ];
        },
      );
    });
  }

  void addCommands(List<ChatCommand> commands) {
    state = [...state, ...commands];
  }

  void clear() {
    state = [];
  }
}
