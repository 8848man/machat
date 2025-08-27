import 'package:flutter/material.dart';
import 'package:machat/features/common/models/ai_model.dart';

class AiModelControllerManager {
  final List<TextEditingController> controllers;

  AiModelControllerManager()
      : controllers = List.generate(6, (_) => TextEditingController());

  /// AiModel 인스턴스를 생성하는 메서드
  AiModel getAiModel() {
    return AiModel(
      name: controllers[0].text.trim(),
      description: _emptyToNull(controllers[1].text),
      traits: _parseTraits(controllers[2].text),
      speakingStyle: _emptyToNull(controllers[3].text),
      role: _emptyToNull(controllers[4].text),
      prompt: _emptyToNull(controllers[5].text),
    );
  }

  /// 기존 모델을 컨트롤러에 주입하는 메서드
  void loadFromAiModel(AiModel model) {
    controllers[0].text = model.name;
    controllers[1].text = model.description ?? '';
    controllers[2].text = model.traits.join(', ');
    controllers[3].text = model.speakingStyle ?? '';
    controllers[4].text = model.role ?? '';
    controllers[5].text = model.prompt ?? '';
  }

  void clear() {
    for (final controller in controllers) {
      controller.clear();
    }
  }

  /// dispose 처리
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }
  }

  // --- 내부 유틸리티 ---

  /// 빈 문자열이면 null 처리
  static String? _emptyToNull(String text) {
    final trimmed = text.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  /// traits 파싱: 콤마 기준으로 split
  static List<String> _parseTraits(String input) {
    return input
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }
}
