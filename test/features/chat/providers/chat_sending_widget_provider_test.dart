import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:machat/features/chat/providers/chat_sending_widget_proivder.dart';

void main() {
  group('Chat Sending Widget Provider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('chatSendingWidgetProvider should provide a Container widget', () {
      final widget = container.read(chatSendingWidgetProvider);
      expect(widget, isA<Container>());
    });

    test('chatSendingWidgetProvider should provide the same widget instance', () {
      final widget1 = container.read(chatSendingWidgetProvider);
      final widget2 = container.read(chatSendingWidgetProvider);
      expect(widget1, equals(widget2));
    });

    test('chatSendingWidgetProvider should provide an empty Container', () {
      final widget = container.read(chatSendingWidgetProvider) as Container;
      expect(widget.child, isNull);
      expect(widget.constraints, isNull);
      expect(widget.color, isNull);
      expect(widget.padding, isNull);
      expect(widget.margin, isNull);
    });
  });
} 