import 'package:flutter/material.dart';

class CommandProtectingController extends TextEditingController {
  final RegExp commandPattern = RegExp(r'/character:[^\s]+');

  CommandProtectingController({super.text});

  /// TextSpan 생성: 커맨드 블록 강조
  @override
  TextSpan buildTextSpan(
      {required BuildContext context, TextStyle? style, bool? withComposing}) {
    final children = <TextSpan>[];
    final text = value.text;
    int start = 0;

    for (final match in commandPattern.allMatches(text)) {
      // 일반 텍스트
      if (match.start > start) {
        children.add(
            TextSpan(text: text.substring(start, match.start), style: style));
      }

      // 커맨드 블록 강조
      children.add(TextSpan(
        text: match.group(0),
        style: style?.copyWith(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          backgroundColor: Colors.blue.withOpacity(0.1),
        ),
      ));

      start = match.end;
    }

    // 마지막 일반 텍스트
    if (start < text.length) {
      children.add(TextSpan(text: text.substring(start), style: style));
    }

    return TextSpan(children: children, style: style);
  }

  /// 커맨드 삽입
  void insertCommand(String command) {
    final selectionStart = selection.start;
    final newText = text.replaceRange(selectionStart, selection.end, command);

    value = TextEditingValue(
      text: newText,
      selection:
          TextSelection.collapsed(offset: selectionStart + command.length),
    );
  }

  /// 단위 삭제 처리 (커맨드 블록 포함)
  @override
  set value(TextEditingValue newValue) {
    final oldText = text;
    final newText = newValue.text;
    final cursorIndex = newValue.selection.baseOffset;

    // 삭제 감지
    if (newText.length < oldText.length) {
      // 커서 위치 기준으로 블록 단위 삭제
      final match = commandPattern.firstMatch(oldText);
      if (match != null &&
          cursorIndex > match.start &&
          cursorIndex <= match.end) {
        // 블록 전체 제거
        final updatedText =
            oldText.replaceRange(match.start, match.end + 1, "");

        super.value = TextEditingValue(
          text: updatedText,
          // 커서 포커스는 블록 시작 위치
          selection: TextSelection.collapsed(offset: match.start),
        );
        return;
      }
    }

    super.value = newValue;
  }
}
