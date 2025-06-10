import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:machat/features/chat/repository/chat_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockCollectionReference extends Mock implements CollectionReference {}
class MockDocumentReference extends Mock implements DocumentReference {}
class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

void main() {
  group('ChatRepository Tests', () {
    late ProviderContainer container;
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference mockChatRoomsCollection;
    late MockDocumentReference mockChatRoomDoc;
    late MockCollectionReference mockChatCollection;
    late MockDocumentReference mockChatDoc;
    late ChatRepository repository;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockChatRoomsCollection = MockCollectionReference();
      mockChatRoomDoc = MockDocumentReference();
      mockChatCollection = MockCollectionReference();
      mockChatDoc = MockDocumentReference();

      container = ProviderContainer();
      repository = ChatRepository(container.read);

      // Setup mock chain
      when(() => mockFirestore.collection('chat_rooms'))
          .thenReturn(mockChatRoomsCollection);
      when(() => mockChatRoomsCollection.doc(any()))
          .thenReturn(mockChatRoomDoc);
      when(() => mockChatRoomDoc.collection('chat'))
          .thenReturn(mockChatCollection);
      when(() => mockChatCollection.doc())
          .thenReturn(mockChatDoc);
    });

    tearDown(() {
      container.dispose();
    });

    group('create', () {
      test('should create a new chat message successfully', () async {
        // Arrange
        final data = {
          'roomId': 'test_room_id',
          'message': 'Hello',
          'userId': 'user123',
        };

        when(() => mockChatDoc.id).thenReturn('new_chat_id');
        when(() => mockChatDoc.set(any())).thenAnswer((_) async => {});

        // Act
        final result = await repository.create(data);

        // Assert
        verify(() => mockChatDoc.set({
          'id': 'new_chat_id',
          'type': 'chat',
          'message': 'Hello',
          'createdBy': 'user123',
          'createdAt': any(named: 'createdAt'),
        })).called(1);
        expect(result, {});
      });

      test('should throw error when required fields are missing', () async {
        // Arrange
        final data = {
          'roomId': 'test_room_id',
          // missing message and userId
        };

        // Act & Assert
        expect(() => repository.create(data), throwsException);
      });
    });

    group('read', () {
      test('should read chat room data successfully', () async {
        // Arrange
        final mockSnapshot = MockDocumentSnapshot();
        final expectedData = {
          'id': 'test_room_id',
          'name': 'Test Room',
        };

        when(() => mockChatRoomDoc.get())
            .thenAnswer((_) async => mockSnapshot);
        when(() => mockSnapshot.exists).thenReturn(true);
        when(() => mockSnapshot.data()).thenReturn(expectedData);

        // Act
        final result = await repository.read('test_room_id');

        // Assert
        expect(result, expectedData);
        verify(() => mockChatRoomDoc.get()).called(1);
      });

      test('should throw error when chat room does not exist', () async {
        // Arrange
        final mockSnapshot = MockDocumentSnapshot();

        when(() => mockChatRoomDoc.get())
            .thenAnswer((_) async => mockSnapshot);
        when(() => mockSnapshot.exists).thenReturn(false);

        // Act & Assert
        expect(() => repository.read('non_existent_room'),
            throwsException);
      });

      test('should throw error when Firestore operation fails', () async {
        // Arrange
        when(() => mockChatRoomDoc.get())
            .thenThrow(Exception('Firestore error'));

        // Act & Assert
        expect(() => repository.read('test_room_id'),
            throwsException);
      });
    });

    group('delete', () {
      test('should throw UnimplementedError', () {
        expect(() => repository.delete('test_id'),
            throwsA(isA<UnimplementedError>()));
      });
    });

    group('readAll', () {
      test('should throw UnimplementedError', () {
        expect(() => repository.readAll(),
            throwsA(isA<UnimplementedError>()));
      });
    });

    group('update', () {
      test('should throw UnimplementedError', () {
        expect(() => repository.update('test_id', {}),
            throwsA(isA<UnimplementedError>()));
      });
    });
  });
} 