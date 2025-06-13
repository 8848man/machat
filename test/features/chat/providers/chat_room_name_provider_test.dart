import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:machat/features/chat/providers/chat_room_name_provider.dart';

void main() {
  group('Chat Room Name Provider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('chatRoomNameProvider should initialize with default value', () {
      final name = container.read(chatRoomNameProvider);
      expect(name, '채팅방');
    });

    test('chatRoomNameProvider should update value correctly', () {
      const newName = 'New Chat Room';
      container.read(chatRoomNameProvider.notifier).state = newName;
      
      final updatedName = container.read(chatRoomNameProvider);
      expect(updatedName, newName);
    });

    test('chatRoomNameProvider should maintain state between reads', () {
      const newName = 'Test Room';
      container.read(chatRoomNameProvider.notifier).state = newName;
      
      final firstRead = container.read(chatRoomNameProvider);
      final secondRead = container.read(chatRoomNameProvider);
      
      expect(firstRead, secondRead);
      expect(firstRead, newName);
    });
  });
} 