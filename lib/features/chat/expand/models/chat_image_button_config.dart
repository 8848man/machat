// 데이터 모델 클래스 생성
import 'package:flutter/material.dart';
import 'package:machat/features/chat/expand/view_models/chat_image_view_model.dart';

class ImageButtonConfig {
  final IconData icon;
  final Future<void> Function(ChatImageViewModel) onPressed;

  const ImageButtonConfig({
    required this.icon,
    required this.onPressed,
  });
}
