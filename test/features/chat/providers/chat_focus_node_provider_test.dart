import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:machat/features/chat/providers/chat_focus_node_provider.dart';

void main() {
  group('Chat Focus Node Provider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('chatFocusNodeProvider should provide a FocusNode instance', () {
      final focusNode = container.read(chatFocusNodeProvider);
      expect(focusNode, isA<FocusNode>());
    });

    test('chatFocusNodeProvider should provide unique FocusNode instances', () {
      final focusNode1 = container.read(chatFocusNodeProvider);
      final focusNode2 = container.read(chatFocusNodeProvider);
      expect(focusNode1, equals(focusNode2));
    });

    test('chatFocusNodeProvider should dispose FocusNode when container is disposed', () {
      final focusNode = container.read(chatFocusNodeProvider);
      expect(focusNode.hasFocus, isFalse);
      
      container.dispose();
      expect(focusNode.hasFocus, isFalse);
    });

    test('chatFocusNodeProvider should maintain focus state', () {
      final focusNode = container.read(chatFocusNodeProvider);
      expect(focusNode.hasFocus, isFalse);
      
      focusNode.requestFocus();
      expect(focusNode.hasFocus, isTrue);
      
      focusNode.unfocus();
      expect(focusNode.hasFocus, isFalse);
    });
  });
} 