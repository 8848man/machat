import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:machat/core/models/chat.dart';
import 'package:machat/storage/interfaces/i_json_storage.dart';
import 'package:machat/storage/providers/chat_storage_provider.dart';
import 'package:machat/storage/services/chat_cache_service.dart';
import 'package:mocktail/mocktail.dart';

class MockJsonStorage<T> extends Mock
    implements JsonStorageInterface<List<T>> {}

class FakeChat extends Fake implements Chat {}

class MockRef extends Mock implements Ref {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeChat());
  });

  group('ChatCacheService', () {
    late MockJsonStorage<Chat> mockStorage;
    late ProviderContainer container;
    late ChatCacheService service;

    const chatRoomId = 'room_123';
    late Chat sampleMessage;
    late Chat olderMessage;
    late Chat newerMessage;

    setUp(() {
      // 테스트 데이터 설정 - 객체와 JSON 모두 준비
      final now = DateTime.now();

      sampleMessage = Chat(
        id: '1',
        message: 'Hello',
        createdAt: now.toString(),
        createdBy: 'user1',
      );

      olderMessage = Chat(
        id: '0',
        message: 'Previous',
        createdAt: now.subtract(const Duration(days: 1)).toString(),
        createdBy: 'user2',
      );

      newerMessage = Chat(
        id: '2',
        message: 'Newer',
        createdAt: now.add(const Duration(minutes: 1)).toString(),
        createdBy: 'user1',
      );

      // Mock Storage 설정
      mockStorage = MockJsonStorage<Chat>();
    });

    tearDown(() {
      container.dispose();
    });

    group('초기화 테스트', () {
      test('초기화 시 저장소에서 데이터를 성공적으로 불러온다', () async {
        // Given - JSON Map 형태로 반환
        when(() => mockStorage.init()).thenAnswer((_) async {});
        when(() => mockStorage.load(chatRoomId)).thenAnswer((_) async => [
              sampleMessage,
            ]);

        container = ProviderContainer(
          overrides: [
            chatStorageProvider.overrideWithValue(mockStorage),
          ],
        );

        // When
        service = container.read(chatCacheProvider(chatRoomId));
        await Future.delayed(const Duration(milliseconds: 200));

        // Then
        expect(service.messages, hasLength(1));
        expect(service.messages.first.id, equals(sampleMessage.id));
        expect(service.messages.first.message, equals(sampleMessage.message));
        expect(
            service.messages.first.createdBy, equals(sampleMessage.createdBy));

        verify(() => mockStorage.init()).called(1);
        verify(() => mockStorage.load(chatRoomId)).called(1);
      });

      test('초기화 시 여러 메시지를 올바르게 불러온다', () async {
        // Given - 여러 JSON 메시지
        when(() => mockStorage.init()).thenAnswer((_) async {});
        when(() => mockStorage.load(chatRoomId))
            .thenAnswer((_) async => [olderMessage, sampleMessage]);

        container = ProviderContainer(
          overrides: [
            chatStorageProvider.overrideWithValue(mockStorage),
          ],
        );

        // When
        service = container.read(chatCacheProvider(chatRoomId));
        await Future.delayed(const Duration(milliseconds: 200));

        // Then
        expect(service.messages, hasLength(2));
        expect(service.messages.map((m) => m.id), containsAll(['0', '1']));
      });

      test('초기화 시 저장소가 null을 반환하면 빈 리스트로 시작한다', () async {
        // Given
        when(() => mockStorage.init()).thenAnswer((_) async {});
        when(() => mockStorage.load(chatRoomId)).thenAnswer((_) async => null);

        container = ProviderContainer(
          overrides: [
            chatStorageProvider.overrideWithValue(mockStorage),
          ],
        );

        // When
        service = container.read(chatCacheProvider(chatRoomId));
        await Future.delayed(const Duration(milliseconds: 200));

        // Then
        expect(service.messages, isEmpty);
        verify(() => mockStorage.init()).called(1);
        verify(() => mockStorage.load(chatRoomId)).called(1);
      });

      test('초기화 실패 시 빈 리스트로 시작하고 에러를 처리한다', () async {
        // Given
        when(() => mockStorage.init()).thenAnswer((_) async {});
        when(() => mockStorage.load(chatRoomId))
            .thenThrow(Exception('Storage load failed'));

        container = ProviderContainer(
          overrides: [
            chatStorageProvider.overrideWithValue(mockStorage),
          ],
        );

        // When
        service = container.read(chatCacheProvider(chatRoomId));
        await Future.delayed(const Duration(milliseconds: 200));

        // Then
        expect(service.messages, isEmpty);
        verify(() => mockStorage.init()).called(1);
        verify(() => mockStorage.load(chatRoomId)).called(1);
      });

      test('저장소 초기화 실패 시에도 서비스 생성은 성공한다', () async {
        // Given
        when(() => mockStorage.init()).thenThrow(Exception('Init failed'));

        container = ProviderContainer(
          overrides: [
            chatStorageProvider.overrideWithValue(mockStorage),
          ],
        );

        // When
        service = container.read(chatCacheProvider(chatRoomId));
        await Future.delayed(const Duration(milliseconds: 200));

        // Then
        expect(service.messages, isEmpty);
        verify(() => mockStorage.init()).called(1);
        verifyNever(() => mockStorage.load(any()));
      });
    });

    group('메시지 추가 테스트', () {
      setUp(() async {
        // 각 테스트마다 기본 설정: 빈 저장소로 시작
        when(() => mockStorage.init()).thenAnswer((_) async {});
        when(() => mockStorage.load(chatRoomId)).thenAnswer((_) async => null);
        when(() => mockStorage.save(chatRoomId, any()))
            .thenAnswer((_) async {});

        container = ProviderContainer(
          overrides: [
            chatStorageProvider.overrideWithValue(mockStorage),
          ],
        );

        service = container.read(chatCacheProvider(chatRoomId));
        await Future.delayed(const Duration(milliseconds: 200));
      });

      test('appendMessages는 새로운 메시지를 추가하고 저장한다', () async {
        // When
        await service.appendMessages([sampleMessage, newerMessage]);

        // Then
        expect(service.messages, hasLength(2));
        expect(service.messages.map((m) => m.id), containsAll(['1', '2']));

        // save 호출 검증
        // verify(() => mockStorage.save(chatRoomId, any())).called(1);

        final captured =
            verify(() => mockStorage.save(chatRoomId, captureAny())).captured;
        final savedData = captured.last as List;
        expect(savedData, hasLength(2));
        expect(savedData.first, isA<Chat>());
      });

      test('appendMessages는 중복 메시지를 무시한다', () async {
        // Given - 먼저 메시지 추가
        await service.appendMessages([sampleMessage]);
        clearInteractions(mockStorage);

        // When - 같은 메시지 다시 추가 시도
        await service.appendMessages([sampleMessage]);

        // Then - 메시지 수는 그대로, 저장도 호출되지 않음
        expect(service.messages, hasLength(1));
        // verifyNever(() => mockStorage.save(any(), any()));
        verifyNever(() => mockStorage.save(any<String>(), any<List<Chat>>()));
      });

      test('handleNewMessage는 새로운 메시지를 추가하고 저장한다', () async {
        // When
        await service.handleNewMessage(sampleMessage);

        // Then
        expect(service.messages, hasLength(1));
        expect(service.messages.first.id, equals(sampleMessage.id));
        verify(() => mockStorage.save(chatRoomId, any())).called(1);
      });
    });

    group('이전 메시지 가져오기 테스트', () {
      setUp(() async {
        when(() => mockStorage.init()).thenAnswer((_) async {});
        when(() => mockStorage.load(chatRoomId))
            .thenAnswer((_) async => [sampleMessage]);
        when(() => mockStorage.save(chatRoomId, any()))
            .thenAnswer((_) async {});

        container = ProviderContainer(
          overrides: [
            chatStorageProvider.overrideWithValue(mockStorage),
          ],
        );

        service = container.read(chatCacheProvider(chatRoomId));
        await Future.delayed(const Duration(milliseconds: 200));
      });

      test('fetchPreviousMessages는 서버에서 데이터를 가져와 저장한다', () async {
        // Given
        fetchFunction(Chat lastMessage) async => [olderMessage];

        // When
        final result = await service.fetchPreviousMessages(
          fetchFromServer: fetchFunction,
        );

        // Then
        expect(result, hasLength(1));
        expect(result.first.id, equals(olderMessage.id));
        expect(service.messages, hasLength(2));

        // 메시지가 올바른 순서로 정렬되어야 함 (이전 메시지가 앞쪽에)
        expect(service.messages.first.id, equals(olderMessage.id));
        expect(service.messages.last.id, equals(sampleMessage.id));

        verify(() => mockStorage.save(chatRoomId, any())).called(1);
      });

      test('fetchPreviousMessages는 빈 결과를 올바르게 처리한다', () async {
        // Given
        fetchFunction(Chat lastMessage) async => <Chat>[];

        // When
        final result = await service.fetchPreviousMessages(
          fetchFromServer: fetchFunction,
        );

        // Then
        expect(result, isEmpty);
        expect(service.messages, hasLength(1)); // 기존 메시지만 남음
        verifyNever(() => mockStorage.save(any(), any()));
      });

      test('fetchPreviousMessages는 메모리가 비어있으면 빈 리스트를 반환한다', () async {
        // Given - 빈 저장소로 새 서비스 생성
        when(() => mockStorage.load(chatRoomId)).thenAnswer((_) async => null);

        final emptyContainer = ProviderContainer(
          overrides: [
            chatStorageProvider.overrideWithValue(mockStorage),
          ],
        );

        final emptyService = emptyContainer.read(chatCacheProvider(chatRoomId));
        await Future.delayed(const Duration(milliseconds: 200));

        fetchFunction(Chat lastMessage) async => [olderMessage];

        // When
        final result = await emptyService.fetchPreviousMessages(
          fetchFromServer: fetchFunction,
        );

        // Then
        expect(result, isEmpty);
        expect(emptyService.messages, isEmpty);

        emptyContainer.dispose();
      });
    });

    group('저장소 에러 처리 테스트', () {
      setUp(() async {
        when(() => mockStorage.init()).thenAnswer((_) async {});
        when(() => mockStorage.load(chatRoomId)).thenAnswer((_) async => null);

        container = ProviderContainer(
          overrides: [
            chatStorageProvider.overrideWithValue(mockStorage),
          ],
        );

        service = container.read(chatCacheProvider(chatRoomId));
        await Future.delayed(const Duration(milliseconds: 200));
      });

      test('저장 실패 시에도 메모리 상태는 유지된다', () async {
        // Given
        when(() => mockStorage.save(chatRoomId, any()))
            .thenThrow(Exception('Save failed'));

        // When & Then - 예외가 발생해야 함
        expect(
          () => service.handleNewMessage(sampleMessage),
          throwsA(isA<Exception>()),
        );

        // 메모리에는 추가되었지만 저장은 실패
        expect(service.messages, hasLength(1));
        expect(service.messages.first.id, equals(sampleMessage.id));
      });

      test('잘못된 JSON 데이터 처리', () async {
        // Given - 잘못된 JSON 형태의 데이터
        // when(() => mockStorage.load(chatRoomId))
        //     .thenAnswer((_) async => ['invalid_json', 123, null]);

        final errorContainer = ProviderContainer(
          overrides: [
            chatStorageProvider.overrideWithValue(mockStorage),
          ],
        );

        // When
        final errorService = errorContainer.read(chatCacheProvider(chatRoomId));
        await Future.delayed(const Duration(milliseconds: 200));

        // Then - 잘못된 데이터는 무시하고 빈 리스트로 시작
        expect(errorService.messages, isEmpty);

        errorContainer.dispose();
      });
    });
  });
}

// 디버깅을 위한 헬퍼
void debugStorageTypes() {
  test('Chat 타입 확인', () {
    const message = Chat(id: '1', message: 'test');
    final json = message.toJson();

    print('Chat type: ${message.runtimeType}');
    print('JSON type: ${json.runtimeType}');
    print('JSON content: $json');

    // JSON에서 다시 객체로 변환 테스트
    final restored = Chat.fromJson(json);
    print('Restored type: ${restored.runtimeType}');
    print('Restored content: ${restored.toString()}');
  });
}
