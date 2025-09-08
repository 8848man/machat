import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/chat/data/models/chat_command.dart';
import 'package:machat/features/chat/presentation/utils/command_setter.dart';
import 'package:machat/features/common/models/ai/ai_model.dart';
import 'package:machat/features/common/providers/ai_character_provider.dart';

// 채팅 커맨드를 저장하는 프로바이더.
// 기본적인 커맨드와 AI 캐릭터 목록을 기반으로 커맨드를 생성합니다.
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
