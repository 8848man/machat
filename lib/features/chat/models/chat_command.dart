import 'dart:ui';

/// 커맨드 모델
class ChatCommand {
  final String text;
  final Color bgColor;

  ChatCommand({
    required this.text,
    this.bgColor = const Color(0xFFD6E8FF), // 기본 연한 파랑
  });

  @override
  String toString() => 'ChatCommand(text: $text, bgColor: $bgColor)';
}
