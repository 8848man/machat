import 'package:flutter/material.dart';
import 'package:machat/features/chat/enums/commands.dart';
import 'package:rwkim_tts/features/tts_service/enums/lib.dart';

class ChatCommand {
  final String text;
  final Color bgColor;

  ChatCommand({
    required this.text,
    this.bgColor = const Color(0xFFD6E8FF),
  });
}

class CommandUtils {
  /// 고정 커맨드 변환
  static List<ChatCommand> fixedCommands({Color? bgColor}) {
    return FixedCommand.values
        .map((c) => ChatCommand(
            text: c.commandText,
            bgColor: bgColor ?? Colors.grey.withOpacity(0.2)))
        .toList();
  }

  /// VoiceCharacter Enum → ChatCommand 변환
  static List<ChatCommand> fromVoiceCharacters(
    List<VoiceCharacter> characters, {
    Color Function(String)? colorMapper,
  }) {
    final commands =
        characters.map((c) => '/character:${c.displayName}').toList();
    return commands
        .map((cmd) => ChatCommand(
              text: cmd,
              bgColor: colorMapper?.call(cmd) ?? Colors.blue.withOpacity(0.2),
            ))
        .toList();
  }

  /// 고정 커맨드 + 캐릭터 커맨드 합치기
  static List<ChatCommand> allCommands(List<VoiceCharacter> characters) {
    final fixed = fixedCommands();
    final characterCommands = fromVoiceCharacters(characters);
    return [...fixed, ...characterCommands];
  }
}
