import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:machat/features/chat/lib.dart';
import 'package:machat/features/chat/providers/chat_focus_node_provider.dart';
import 'package:machat/features/chat/providers/chat_room_name_provider.dart';
import 'package:machat/features/common/layouts/lib.dart';

void main() {
  group('ChatScreen Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('ChatScreen should render all required widgets',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: ChatScreen(),
          ),
        ),
      );

      // Assert
      expect(find.byType(ChatScreen), findsOneWidget);
      expect(find.byType(DefaultLayout), findsOneWidget);
      expect(find.byType(ChatContents), findsOneWidget);
      expect(find.byType(ChatInput), findsOneWidget);
      expect(find.byType(ChatSendingContents), findsOneWidget);
      expect(find.byType(ChatExpand), findsOneWidget);
    });

    testWidgets('ChatScreen should display correct title from provider',
        (WidgetTester tester) async {
      // Arrange
      const testTitle = 'Test Chat Room';
      container.updateOverrides([
        chatRoomNameProvider.overrideWith((ref) => testTitle),
      ]);

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: ChatScreen(),
          ),
        ),
      );

      // Assert
      expect(find.text(testTitle), findsOneWidget);
    });

    testWidgets('ChatScreen should maintain focus node',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: ChatScreen(),
          ),
        ),
      );

      // Act
      final focusNode = container.read(chatFocusNodeProvider);

      // Assert
      expect(focusNode, isNotNull);
      expect(focusNode.hasFocus, isFalse);
    });

    testWidgets('ChatScreen should have correct layout structure',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: ChatScreen(),
          ),
        ),
      );

      // Assert
      final columnFinder = find.byType(Column);
      expect(columnFinder, findsOneWidget);

      final Column column = tester.widget(columnFinder);
      expect(column.children.length,
          4); // ChatContents, ChatInput, ChatSendingContents, ChatExpand
    });

    testWidgets('ChatScreen should handle widget expansion correctly',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: ChatScreen(),
          ),
        ),
      );

      // Assert
      final expandedFinder = find.byType(Expanded);
      expect(expandedFinder, findsOneWidget);

      final Expanded expanded = tester.widget(expandedFinder);
      expect(expanded.child, isA<ChatContents>());
    });
  });
}
