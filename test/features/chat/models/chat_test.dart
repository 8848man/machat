import 'package:flutter_test/flutter_test.dart';
import 'package:machat/features/chat/models/chat.dart';

void main() {
  group('Chat Model Tests', () {
    test('Chat.fromJson should create a Chat instance with correct values', () {
      final json = {
        'message': 'Hello',
        'createdBy': 'user123',
        'createdAt': '2023-01-01T00:00:00Z',
        'isMine': false,
      };
      final chat = Chat.fromJson(json);
      expect(chat.message, 'Hello');
      expect(chat.createdBy, 'user123');
      expect(chat.createdAt, '2023-01-01T00:00:00Z');
      expect(chat.isMine, false);
    });

    test(
        'Chat.toJson should convert a Chat instance to a Map with correct values',
        () {
      final chat = Chat(
        message: 'Hello',
        createdBy: 'user123',
        createdAt: '2023-01-01T00:00:00Z',
        isMine: false,
      );
      final json = chat.toJson();
      expect(json['message'], 'Hello');
      expect(json['createdBy'], 'user123');
      expect(json['createdAt'], '2023-01-01T00:00:00Z');
      expect(json['isMine'], false);
    });

    test('Chat.copyWith should create a new Chat instance with updated values',
        () {
      final chat = Chat(
        message: 'Hello',
        createdBy: 'user123',
        createdAt: '2023-01-01T00:00:00Z',
        isMine: false,
      );
      final updatedChat = chat.copyWith(message: 'Updated Message');
      expect(updatedChat.message, 'Updated Message');
      expect(updatedChat.createdBy, 'user123');
      expect(updatedChat.createdAt, '2023-01-01T00:00:00Z');
      expect(updatedChat.isMine, false);
    });

    test('Chat equality operator should work correctly', () {
      final chat1 = Chat(
        message: 'Hello',
        createdBy: 'user123',
        createdAt: '2023-01-01T00:00:00Z',
        isMine: false,
      );
      final chat2 = Chat(
        message: 'Hello',
        createdBy: 'user123',
        createdAt: '2023-01-01T00:00:00Z',
        isMine: false,
      );
      final chat3 = Chat(
        message: 'Different',
        createdBy: 'user123',
        createdAt: '2023-01-01T00:00:00Z',
        isMine: false,
      );
      expect(chat1, equals(chat2));
      expect(chat1, isNot(equals(chat3)));
    });

    test(
        'Chat.toString should return a string representation of the Chat instance',
        () {
      final chat = Chat(
        message: 'Hello',
        createdBy: 'user123',
        createdAt: '2023-01-01T00:00:00Z',
        isMine: false,
      );
      final expectedString =
          'Chat(message: Hello, createdBy: user123, createdAt: 2023-01-01T00:00:00Z, isMine: false)';
      expect(chat.toString(), expectedString);
    });

    test('Chat.hashCode should be consistent with equality', () {
      final chat1 = Chat(
        message: 'Hello',
        createdBy: 'user123',
        createdAt: '2023-01-01T00:00:00Z',
        isMine: false,
      );
      final chat2 = Chat(
        message: 'Hello',
        createdBy: 'user123',
        createdAt: '2023-01-01T00:00:00Z',
        isMine: false,
      );
      expect(chat1.hashCode, equals(chat2.hashCode));
    });

    test('Chat.fromJson should handle missing fields correctly', () {
      final json = {
        'message': 'Hello',
        'createdBy': 'user123',
        'createdAt': '2023-01-01T00:00:00Z',
      };
      final chat = Chat.fromJson(json);
      expect(chat.message, 'Hello');
      expect(chat.createdBy, 'user123');
      expect(chat.createdAt, '2023-01-01T00:00:00Z');
      expect(chat.isMine, false);
    });

    test('Chat.fromJson should handle null values correctly', () {
      final json = {
        'message': 'Hello',
        'createdBy': 'user123',
        'createdAt': '2023-01-01T00:00:00Z',
        'isMine': null,
      };
      final chat = Chat.fromJson(json);
      expect(chat.message, 'Hello');
      expect(chat.createdBy, 'user123');
      expect(chat.createdAt, '2023-01-01T00:00:00Z');
      expect(chat.isMine, false);
    });

    test('Chat.fromJson should handle invalid JSON correctly', () {
      final json = {
        'message': 'Hello',
        'createdBy': 'user123',
        'createdAt': '2023-01-01T00:00:00Z',
        'isMine': 'invalid',
      };
      expect(() => Chat.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('Chat.fromJson should handle empty JSON correctly', () {
      final Map<String, dynamic> json = {};
      expect(() => Chat.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('Chat.fromJson should handle extra fields correctly', () {
      final json = {
        'message': 'Hello',
        'createdBy': 'user123',
        'createdAt': '2023-01-01T00:00:00Z',
        'isMine': false,
        'extraField': 'extra',
      };
      final chat = Chat.fromJson(json);
      expect(chat.message, 'Hello');
      expect(chat.createdBy, 'user123');
      expect(chat.createdAt, '2023-01-01T00:00:00Z');
      expect(chat.isMine, false);
    });

    test('Chat.fromJson should handle invalid field types correctly', () {
      final json = {
        'message': 123,
        'createdBy': 'user123',
        'createdAt': '2023-01-01T00:00:00Z',
        'isMine': false,
      };
      expect(() => Chat.fromJson(json), throwsA(isA<TypeError>()));
    });
  });
}
