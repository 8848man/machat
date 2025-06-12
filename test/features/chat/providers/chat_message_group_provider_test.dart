import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:machat/features/chat/providers/chat_message_group_provider.dart';
import 'package:machat/features/common/providers/chat_room_id.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock implements CollectionReference {}

class MockDocumentReference extends Mock implements DocumentReference {}

class MockQuerySnapshot extends Mock implements QuerySnapshot {}

class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot {}

void main() {
  group('Chat Message Group Provider Tests', () {
    late ProviderContainer container;
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference mockChatCollection;
    late MockCollectionReference mockImageCollection;
    late MockDocumentReference mockChatRoomDoc;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockChatCollection = MockCollectionReference();
      mockImageCollection = MockCollectionReference();
      mockChatRoomDoc = MockDocumentReference();

      container = ProviderContainer(
        overrides: [
          chatRoomIdProvider.overrideWithValue('test_room_id'),
        ],
      );

      when(() => mockFirestore.collection('chat_rooms'))
          .thenReturn(mockChatCollection);
      when(() => mockChatCollection.doc('test_room_id'))
          .thenReturn(mockChatRoomDoc);
      when(() => mockChatRoomDoc.collection('chat'))
          .thenReturn(mockChatCollection);
      when(() => mockChatRoomDoc.collection('images'))
          .thenReturn(mockImageCollection);
    });

    tearDown(() {
      container.dispose();
    });

    test(
        'mergedChatStreamProvider should return empty stream when roomId is empty',
        () {
      container.updateOverrides([
        chatRoomIdProvider.overrideWithValue(''),
      ]);

      final stream = container.read(mergedChatStreamProvider.stream);
      expect(stream, emitsDone);
    });

    test('mergedChatStreamProvider should merge chat and image streams',
        () async {
      final mockChatSnapshot = MockQuerySnapshot();
      final mockImageSnapshot = MockQuerySnapshot();
      final mockChatDoc = MockQueryDocumentSnapshot();
      final mockImageDoc = MockQueryDocumentSnapshot();

      when(() => mockChatDoc.data()).thenReturn({
        'id': 'chat1',
        'createdBy': 'user1',
        'createdAt': Timestamp.now(),
        'message': 'Hello',
        'type': 'chat',
      });

      when(() => mockImageDoc.data()).thenReturn({
        'id': 'image1',
        'createdBy': 'user2',
        'createdAt': Timestamp.now(),
        'imageUrl': 'https://example.com/image.jpg',
        'type': 'image',
      });

      when(() => mockChatSnapshot.docs).thenReturn([mockChatDoc]);
      when(() => mockImageSnapshot.docs).thenReturn([mockImageDoc]);

      when(() => mockChatCollection.orderBy('createdAt', descending: false))
          .thenReturn(mockChatCollection);
      when(() => mockImageCollection.orderBy('createdAt', descending: false))
          .thenReturn(mockImageCollection);

      when(() => mockChatCollection.snapshots())
          .thenAnswer((_) => Stream.value(mockChatSnapshot));
      when(() => mockImageCollection.snapshots())
          .thenAnswer((_) => Stream.value(mockImageSnapshot));

      final stream = container.read(mergedChatStreamProvider.stream);
      final result = await stream.first;

      expect(result.length, 2);
      expect(result[0]['type'], 'chat');
      expect(result[1]['type'], 'image');
    });

    test('mergedChatStreamProvider should handle duplicate messages', () async {
      final mockChatSnapshot = MockQuerySnapshot();
      final mockChatDoc = MockQueryDocumentSnapshot();

      when(() => mockChatDoc.data()).thenReturn({
        'id': 'chat1',
        'createdBy': 'user1',
        'createdAt': Timestamp.now(),
        'message': 'Hello',
        'type': 'chat',
      });

      when(() => mockChatSnapshot.docs).thenReturn([mockChatDoc, mockChatDoc]);

      when(() => mockChatCollection.orderBy('createdAt', descending: false))
          .thenReturn(mockChatCollection);
      when(() => mockImageCollection.orderBy('createdAt', descending: false))
          .thenReturn(mockImageCollection);

      when(() => mockChatCollection.snapshots())
          .thenAnswer((_) => Stream.value(mockChatSnapshot));
      when(() => mockImageCollection.snapshots())
          .thenAnswer((_) => Stream.value(MockQuerySnapshot()));

      final stream = container.read(mergedChatStreamProvider.stream);
      final result = await stream.first;

      expect(result.length, 1);
      expect(result[0]['id'], 'chat1');
    });

    test('mergedChatStreamProvider should sort messages by createdAt',
        () async {
      final mockChatSnapshot = MockQuerySnapshot();
      final mockChatDoc1 = MockQueryDocumentSnapshot();
      final mockChatDoc2 = MockQueryDocumentSnapshot();

      final now = DateTime.now();
      when(() => mockChatDoc1.data()).thenReturn({
        'id': 'chat1',
        'createdBy': 'user1',
        'createdAt': Timestamp.fromDate(now.add(const Duration(minutes: 1))),
        'message': 'Later message',
        'type': 'chat',
      });

      when(() => mockChatDoc2.data()).thenReturn({
        'id': 'chat2',
        'createdBy': 'user1',
        'createdAt': Timestamp.fromDate(now),
        'message': 'Earlier message',
        'type': 'chat',
      });

      when(() => mockChatSnapshot.docs)
          .thenReturn([mockChatDoc1, mockChatDoc2]);

      when(() => mockChatCollection.orderBy('createdAt', descending: false))
          .thenReturn(mockChatCollection);
      when(() => mockImageCollection.orderBy('createdAt', descending: false))
          .thenReturn(mockImageCollection);

      when(() => mockChatCollection.snapshots())
          .thenAnswer((_) => Stream.value(mockChatSnapshot));
      when(() => mockImageCollection.snapshots())
          .thenAnswer((_) => Stream.value(MockQuerySnapshot()));

      final stream = container.read(mergedChatStreamProvider.stream);
      final result = await stream.first;

      expect(result.length, 2);
      expect(result[0]['message'], 'Earlier message');
      expect(result[1]['message'], 'Later message');
    });
  });
}
