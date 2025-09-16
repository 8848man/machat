import 'package:machat/features/chat/data/models/chat_command.dart';

List<String> getCharacterString({
  required List<ChatCommand> commands,
  required String createdBy,
}) {
  List<String> matchedCharacterTexts = commands
      .where((command) {
        final textWithoutPrefix = command.text.startsWith('/character:')
            ? command.text.replaceFirst('/character:', '').trim()
            : command.text.trim();

        return textWithoutPrefix == createdBy;
      })
      .map((command) => command.text.startsWith('/character:')
          ? command.text.replaceFirst('/character:', '').trim()
          : command.text.trim()) // 여기도 처리
      .toList();

  return matchedCharacterTexts;
}
