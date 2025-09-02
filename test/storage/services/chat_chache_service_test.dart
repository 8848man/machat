import 'package:flutter_test/flutter_test.dart';
import 'package:machat/storage/interfaces/i_json_storage.dart';
import 'package:machat/storage/models/storage_chat.dart';
import 'package:machat/storage/providers/chat_storage_provider.dart';
import 'package:machat/storage/services/chat_cache_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';

class MockJsonStorage extends Mock
    implements JsonStorageInterface<List<StorageChat>> {}

class FakeStorageChat extends Fake implements StorageChat {}

class MockRef extends Mock implements Ref {}

class FakeProvider extends Fake
    implements ProviderBase<JsonStorageInterface<List<StorageChat>>> {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeStorageChat());
    registerFallbackValue(FakeProvider());
  });

  group('ChatCacheService', () {
    late MockJsonStorage mockStorage;
    late ChatCacheService service;
    late MockRef mockRef;

    const chatRoomId = 'room_123';
    late StorageChat sampleMessage;
    late StorageChat olderMessage;
    late StorageChat newerMessage;

    setUp(() {
      // 테스트 데이터 설정 - 매번 새로운 DateTime으로 생성
      final now = DateTime.now();
      sampleMessage = StorageChat(
        id: '1',
        message: 'Hello',
        createdAt: now,
        createdBy: 'user1',
      );

      olderMessage = StorageChat(
        id: '0',
        message: 'Previous',
        createdAt: now.subtract(const Duration(days: 1)),
        createdBy: 'user2',
      );

      newerMessage = StorageChat(
        id: '2',
        message: 'Newer',
        createdAt: now.add(const Duration(minutes: 1)),
        createdBy: 'user1',
      );

      // Mock 객체 초기화
      mockStorage = MockJsonStorage();
      mockRef = MockRef();

      // Provider 모킹 - 구체적인 provider 사용 (권장)
      when(() => mockRef.read(chatStorageProvider)).thenReturn(mockStorage);

      // any() 매처를 사용하는 경우의 대안
      // when(() => mockRef.read<JsonStorageInterface<List<StorageChat>>>(
      //     any<ProviderBase<JsonStorageInterface<List<StorageChat>>>>()))
      //     .thenReturn(mockStorage);
    });

    group('초기화 테스트', () {
      test('초기화 시 저장소에서 데이터를 성공적으로 불러온다', () async {
        // Given
        when(() => mockStorage.init()).thenAnswer((_) async {});
        when(() => mockStorage.load(chatRoomId))
            .thenAnswer((_) async => [sampleMessage]);

        // When
        service = ChatCacheService(chatRoomId: chatRoomId, ref: mockRef);
        await _waitForInitialization();

        // Then
        expect(service.messages, hasLength(1));
        expect(service.messages.first.id, equals(sampleMessage.id));
        expect(service.messages.first.message, equals(sampleMessage.message));

        verify(() => mockStorage.init()).called(1);
        verify(() => mockStorage.load(chatRoomId)).called(1);
      });

      test('초기화 실패 시 빈 리스트로 시작하고 에러를 처리한다', () async {
        // Given
        when(() => mockStorage.init()).thenAnswer((_) async {});
        when(() => mockStorage.load(chatRoomId))
            .thenThrow(Exception('Storage load failed'));

        // When
        service = ChatCacheService(chatRoomId: chatRoomId, ref: mockRef);
        await _waitForInitialization();

        // Then
        expect(service.messages, isEmpty);
        verify(() => mockStorage.init()).called(1);
        verify(() => mockStorage.load(chatRoomId)).called(1);
      });

      test('저장소 초기화 실패 시에도 서비스가 정상 작동한다', () async {
        // Given
        when(() => mockStorage.init()).thenThrow(Exception('Init failed'));

        // When
        service = ChatCacheService(chatRoomId: chatRoomId, ref: mockRef);
        await _waitForInitialization();

        // Then
        expect(service.messages, isEmpty);
        verify(() => mockStorage.init()).called(1);
        verifyNever(() => mockStorage.load(any()));
      });
    });

    group('메시지 추가 테스트', () {
      setUp(() async {
        // 각 테스트마다 기본 설정
        when(() => mockStorage.init()).thenAnswer((_) async {});
        when(() => mockStorage.load(chatRoomId)).thenAnswer((_) async => []);
        when(() => mockStorage.save(chatRoomId, any()))
            .thenAnswer((_) async {});

        service = ChatCacheService(chatRoomId: chatRoomId, ref: mockRef);
        await _waitForInitialization();
      });

      test('appendMessages는 새로운 메시지를 추가하고 저장한다', () async {
        // When
        await service.appendMessages([sampleMessage, newerMessage]);

        // Then
        expect(service.messages, hasLength(2));
        expect(service.messages.map((m) => m.id), containsAll(['1', '2']));
        verify(() => mockStorage.save(chatRoomId, any())).called(1);
      });

      test('appendMessages는 중복 메시지를 무시한다', () async {
        // Given - 먼저 메시지 추가
        await service.appendMessages([sampleMessage]);
        clearInteractions(mockStorage);

        // When - 같은 메시지 다시 추가
        await service.appendMessages([sampleMessage]);

        // Then
        expect(service.messages, hasLength(1));
        verifyNever(() => mockStorage.save(any(), any()));
      });

      test('appendMessages는 부분적으로 중복된 메시지 리스트를 올바르게 처리한다', () async {
        // Given
        await service.appendMessages([sampleMessage]);
        clearInteractions(mockStorage);

        // When - 중복과 새로운 메시지 혼합
        await service.appendMessages([sampleMessage, newerMessage]);

        // Then
        expect(service.messages, hasLength(2));
        expect(service.messages.any((m) => m.id == newerMessage.id), isTrue);
        verify(() => mockStorage.save(chatRoomId, any())).called(1);
      });

      test('handleNewMessage는 새로운 메시지를 추가하고 저장한다', () async {
        // When
        await service.handleNewMessage(sampleMessage);

        // Then
        expect(service.messages, hasLength(1));
        expect(service.messages.first.id, equals(sampleMessage.id));
        verify(() => mockStorage.save(chatRoomId, any())).called(1);
      });

      test('handleNewMessage는 중복 메시지를 무시한다', () async {
        // Given
        await service.handleNewMessage(sampleMessage);
        clearInteractions(mockStorage);

        // When
        await service.handleNewMessage(sampleMessage);

        // Then
        expect(service.messages, hasLength(1));
        verifyNever(() => mockStorage.save(any(), any()));
      });
    });

    group('이전 메시지 가져오기 테스트', () {
      setUp(() async {
        when(() => mockStorage.init()).thenAnswer((_) async {});
        when(() => mockStorage.load(chatRoomId)).thenAnswer((_) async => []);
        when(() => mockStorage.save(chatRoomId, any()))
            .thenAnswer((_) async {});

        service = ChatCacheService(chatRoomId: chatRoomId, ref: mockRef);
        await _waitForInitialization();
      });

      test('fetchPreviousMessages는 서버에서 데이터를 가져와 저장한다', () async {
        // Given
        final fetchFunction =
            (StorageChat? lastMessage) async => [olderMessage];

        // When
        final result = await service.fetchPreviousMessages(
          fetchFromServer: fetchFunction,
        );

        // Then
        expect(result, hasLength(1));
        expect(result.first.id, equals(olderMessage.id));
        expect(service.messages, hasLength(1));
        expect(service.messages.first.id, equals(olderMessage.id));
        verify(() => mockStorage.save(chatRoomId, any())).called(1);
      });

      test('fetchPreviousMessages는 빈 결과를 올바르게 처리한다', () async {
        // Given
        final fetchFunction =
            (StorageChat? lastMessage) async => <StorageChat>[];

        // When
        final result = await service.fetchPreviousMessages(
          fetchFromServer: fetchFunction,
        );

        // Then
        expect(result, isEmpty);
        expect(service.messages, isEmpty);
        verifyNever(() => mockStorage.save(any(), any()));
      });

      test('fetchPreviousMessages는 기존 메시지와 함께 정렬된다', () async {
        // Given
        await service.handleNewMessage(sampleMessage);
        clearInteractions(mockStorage);

        final fetchFunction =
            (StorageChat? lastMessage) async => [olderMessage];

        // When
        final result = await service.fetchPreviousMessages(
          fetchFromServer: fetchFunction,
        );

        // Then
        expect(result, hasLength(1));
        expect(service.messages, hasLength(2));
        // 메시지가 시간순으로 정렬되어야 함 (오래된 것부터)
        expect(service.messages.first.id, equals(olderMessage.id));
        expect(service.messages.last.id, equals(sampleMessage.id));
      });

      test('fetchPreviousMessages 서버 에러 시 예외를 전파한다', () async {
        // Given
        final fetchFunction = (StorageChat? lastMessage) async {
          throw Exception('Server error');
        };

        // When & Then
        expect(
          () => service.fetchPreviousMessages(fetchFromServer: fetchFunction),
          throwsA(isA<Exception>()),
        );
        verifyNever(() => mockStorage.save(any(), any()));
      });
    });

    group('저장소 에러 처리 테스트', () {
      setUp(() async {
        when(() => mockStorage.init()).thenAnswer((_) async {});
        when(() => mockStorage.load(chatRoomId)).thenAnswer((_) async => []);

        service = ChatCacheService(chatRoomId: chatRoomId, ref: mockRef);
        await _waitForInitialization();
      });

      test('저장 실패 시에도 메모리 상태는 유지된다', () async {
        // Given
        when(() => mockStorage.save(chatRoomId, any()))
            .thenThrow(Exception('Save failed'));

        // When
        await service.handleNewMessage(sampleMessage);

        // Then - 메모리에는 추가되었지만 저장은 실패
        expect(service.messages, hasLength(1));
        expect(service.messages.first.id, equals(sampleMessage.id));
        verify(() => mockStorage.save(chatRoomId, any())).called(1);
      });
    });
  });
}

// Helper method for waiting initialization
Future<void> _waitForInitialization() async {
  // 초기화가 비동기로 처리되므로 충분한 시간을 기다림
  await Future.delayed(const Duration(milliseconds: 100));
}
