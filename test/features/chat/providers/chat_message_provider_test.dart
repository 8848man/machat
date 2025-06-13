import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:machat/features/chat/providers/chat_message_provider.dart';
import 'package:machat/features/common/providers/chat_room_id.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockCollectionReference extends Mock implements CollectionReference {}
class MockDocumentReference extends Mock implements DocumentReference {}
class MockQuerySnapshot extends Mock implements QuerySnapshot {}
class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot {}

void main() {
  group('Chat Message Provider Tests', () {
    late ProviderContainer container;
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference mockChatCollection;
    late MockDocumentReference mockChatRoomDoc;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockChatCollection = MockCollectionReference();
      mockChatRoomDoc = MockDocumentReference();

      container = ProviderContainer(
        overrides: [
          chatRoomIdProvider.overrideWithValue('test_room_id'),
        ],
      );

      when(() => mockFirestore.collection('chat_rooms')).thenReturn(mockChatCollection);
      when(() => mockChatCollection.doc('test_room_id')).thenReturn(mockChatRoomDoc);
      when(() => mockChatRoomDoc.collection('chat')).thenReturn(mockChatCollection);
    });

    tearDown(() {
      container.dispose();
    });

    test('chatStreamProvider should return empty stream when roomId is empty', () {
      container.updateOverrides([
        chatRoomIdProvider.overrideWithValue(''),
      ]);

      final stream = container.read(chatStreamProvider.stream);
      expect(stream, emitsDone);
    });

    test('getChatData should transform snapshot data correctly', () {
      final mockSnapshot = MockQuerySnapshot();
      final mockDoc = MockQueryDocumentSnapshot();
      final now = DateTime.now();

      when(() => mockDoc.data()).thenReturn({
        'createdBy': 'user1',
        'createdAt': Timestamp.fromDate(now),
        'message': 'Hello',
      });

      when(() => mockSnapshot.docs).thenReturn([mockDoc]);

      final result = getChatData(mockSnapshot);

      expect(result.length, 1);
      expect(result[0]['createdBy'], 'user1');
      expect(result[0]['message'], 'Hello');
      expect(result[0]['isMine'], false);
    });

    test('getChatData should handle missing createdAt field', () {
      final mockSnapshot = MockQuerySnapshot();
      final mockDoc = MockQueryDocumentSnapshot();

      when(() => mockDoc.data()).thenReturn({
        'createdBy': 'user1',
        'message': 'Hello',
      });

      when(() => mockSnapshot.docs).thenReturn([mockDoc]);

      final result = getChatData(mockSnapshot);

      expect(result.length, 1);
      expect(result[0]['createdAt'], isNotEmpty);
    });

    test('getChatData should handle missing createdBy field', () {
      final mockSnapshot = MockQuerySnapshot();
      final mockDoc = MockQueryDocumentSnapshot();

      when(() => mockDoc.data()).thenReturn({
        'createdAt': Timestamp.now(),
        'message': 'Hello',
      });

      when(() => mockSnapshot.docs).thenReturn([mockDoc]);

      final result = getChatData(mockSnapshot);

      expect(result.length, 1);
      expect(result[0]['createdBy'], '');
    });

    test('getChatData should handle currentUserId correctly', () {
      final mockSnapshot = MockQuerySnapshot();
      final mockDoc = MockQueryDocumentSnapshot();

      when(() => mockDoc.data()).thenReturn({
        'createdBy': 'currentUserId',
        'createdAt': Timestamp.now(),
        'message': 'Hello',
      });

      when(() => mockSnapshot.docs).thenReturn([mockDoc]);

      final result = getChatData(mockSnapshot);

      expect(result.length, 1);
      expect(result[0]['isMine'], true);
    });

    test('getChatData should handle multiple documents', () {
      final mockSnapshot = MockQuerySnapshot();
      final mockDoc1 = MockQueryDocumentSnapshot();
      final mockDoc2 = MockQueryDocumentSnapshot();

      when(() => mockDoc1.data()).thenReturn({
        'createdBy': 'user1',
        'createdAt': Timestamp.now(),
        'message': 'Hello',
      });

      when(() => mockDoc2.data()).thenReturn({
        'createdBy': 'user2',
        'createdAt': Timestamp.now(),
        'message': 'Hi',
      });

      when(() => mockSnapshot.docs).thenReturn([mockDoc1, mockDoc2]);

      final result = getChatData(mockSnapshot);

      expect(result.length, 2);
      expect(result[0]['message'], 'Hello');
      expect(result[1]['message'], 'Hi');
    });

    test('getChatData should throw error for invalid data', () {
      final mockSnapshot = MockQuerySnapshot();
      final mockDoc = MockQueryDocumentSnapshot();

      when(() => mockDoc.data()).thenThrow(Exception('Invalid data'));
      when(() => mockSnapshot.docs).thenReturn([mockDoc]);

      expect(() => getChatData(mockSnapshot), throwsException);
    });
  });
} 