import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:machat/features/chat/providers/chat_image_provider.dart';
import 'package:machat/features/common/providers/chat_room_id.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockCollectionReference extends Mock implements CollectionReference {}
class MockDocumentReference extends Mock implements DocumentReference {}
class MockQuerySnapshot extends Mock implements QuerySnapshot {}
class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot {}

void main() {
  group('Chat Image Provider Tests', () {
    late ProviderContainer container;
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference mockImageCollection;
    late MockDocumentReference mockChatRoomDoc;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockImageCollection = MockCollectionReference();
      mockChatRoomDoc = MockDocumentReference();

      container = ProviderContainer(
        overrides: [
          chatRoomIdProvider.overrideWithValue('test_room_id'),
        ],
      );

      when(() => mockFirestore.collection('chat_rooms')).thenReturn(mockImageCollection);
      when(() => mockImageCollection.doc('test_room_id')).thenReturn(mockChatRoomDoc);
      when(() => mockChatRoomDoc.collection('images')).thenReturn(mockImageCollection);
    });

    tearDown(() {
      container.dispose();
    });

    test('chatImageStreamProvider should return empty stream when roomId is empty', () {
      container.updateOverrides([
        chatRoomIdProvider.overrideWithValue(''),
      ]);

      final stream = container.read(chatImageStreamProvider.stream);
      expect(stream, emitsDone);
    });

    test('chatImageStreamProvider should transform image data correctly', () async {
      final mockSnapshot = MockQuerySnapshot();
      final mockDoc = MockQueryDocumentSnapshot();
      final now = DateTime.now();

      when(() => mockDoc.data()).thenReturn({
        'senderId': 'user1',
        'timestamp': Timestamp.fromDate(now),
        'imageUrl': 'https://example.com/image.jpg',
      });

      when(() => mockSnapshot.docs).thenReturn([mockDoc]);

      when(() => mockImageCollection.orderBy('timestamp', descending: false))
          .thenReturn(mockImageCollection);
      when(() => mockImageCollection.snapshots())
          .thenAnswer((_) => Stream.value(mockSnapshot));

      final stream = container.read(chatImageStreamProvider.stream);
      final result = await stream.first;

      expect(result.length, 1);
      expect(result[0]['createdBy'], 'user1');
      expect(result[0]['imageUrl'], 'https://example.com/image.jpg');
      expect(result[0]['isMine'], false);
    });

    test('chatImageStreamProvider should handle missing timestamp field', () async {
      final mockSnapshot = MockQuerySnapshot();
      final mockDoc = MockQueryDocumentSnapshot();

      when(() => mockDoc.data()).thenReturn({
        'senderId': 'user1',
        'imageUrl': 'https://example.com/image.jpg',
      });

      when(() => mockSnapshot.docs).thenReturn([mockDoc]);

      when(() => mockImageCollection.orderBy('timestamp', descending: false))
          .thenReturn(mockImageCollection);
      when(() => mockImageCollection.snapshots())
          .thenAnswer((_) => Stream.value(mockSnapshot));

      final stream = container.read(chatImageStreamProvider.stream);
      final result = await stream.first;

      expect(result.length, 1);
      expect(result[0]['createdAt'], isNotEmpty);
    });

    test('chatImageStreamProvider should handle missing senderId field', () async {
      final mockSnapshot = MockQuerySnapshot();
      final mockDoc = MockQueryDocumentSnapshot();

      when(() => mockDoc.data()).thenReturn({
        'timestamp': Timestamp.now(),
        'imageUrl': 'https://example.com/image.jpg',
      });

      when(() => mockSnapshot.docs).thenReturn([mockDoc]);

      when(() => mockImageCollection.orderBy('timestamp', descending: false))
          .thenReturn(mockImageCollection);
      when(() => mockImageCollection.snapshots())
          .thenAnswer((_) => Stream.value(mockSnapshot));

      final stream = container.read(chatImageStreamProvider.stream);
      final result = await stream.first;

      expect(result.length, 1);
      expect(result[0]['createdBy'], '');
    });

    test('chatImageStreamProvider should handle currentUserId correctly', () async {
      final mockSnapshot = MockQuerySnapshot();
      final mockDoc = MockQueryDocumentSnapshot();

      when(() => mockDoc.data()).thenReturn({
        'senderId': 'currentUserId',
        'timestamp': Timestamp.now(),
        'imageUrl': 'https://example.com/image.jpg',
      });

      when(() => mockSnapshot.docs).thenReturn([mockDoc]);

      when(() => mockImageCollection.orderBy('timestamp', descending: false))
          .thenReturn(mockImageCollection);
      when(() => mockImageCollection.snapshots())
          .thenAnswer((_) => Stream.value(mockSnapshot));

      final stream = container.read(chatImageStreamProvider.stream);
      final result = await stream.first;

      expect(result.length, 1);
      expect(result[0]['isMine'], true);
    });

    test('chatImageStreamProvider should handle multiple images', () async {
      final mockSnapshot = MockQuerySnapshot();
      final mockDoc1 = MockQueryDocumentSnapshot();
      final mockDoc2 = MockQueryDocumentSnapshot();

      when(() => mockDoc1.data()).thenReturn({
        'senderId': 'user1',
        'timestamp': Timestamp.now(),
        'imageUrl': 'https://example.com/image1.jpg',
      });

      when(() => mockDoc2.data()).thenReturn({
        'senderId': 'user2',
        'timestamp': Timestamp.now(),
        'imageUrl': 'https://example.com/image2.jpg',
      });

      when(() => mockSnapshot.docs).thenReturn([mockDoc1, mockDoc2]);

      when(() => mockImageCollection.orderBy('timestamp', descending: false))
          .thenReturn(mockImageCollection);
      when(() => mockImageCollection.snapshots())
          .thenAnswer((_) => Stream.value(mockSnapshot));

      final stream = container.read(chatImageStreamProvider.stream);
      final result = await stream.first;

      expect(result.length, 2);
      expect(result[0]['imageUrl'], 'https://example.com/image1.jpg');
      expect(result[1]['imageUrl'], 'https://example.com/image2.jpg');
    });
  });
} 