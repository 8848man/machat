import 'dart:ui';

/// 커맨드 모델
class ChatCommand {
  final String text;
  final Color bgColor;
  final Map<String, String>? data;

  ChatCommand({
    required this.text,
    this.bgColor = const Color(0xFFD6E8FF),
    this.data,
  });
}
