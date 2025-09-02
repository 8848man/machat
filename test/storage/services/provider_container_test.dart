import 'package:flutter_test/flutter_test.dart';
import 'package:machat/storage/interfaces/i_json_storage.dart';
import 'package:machat/storage/models/storage_chat.dart';
import 'package:machat/storage/services/chat_cache_service.dart';
import 'package:mocktail/mocktail.dart';

import 'chat_chache_service_test.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(FakeStorageChat());
  });

  group('ChatCacheService Debug', () {
    late MockJsonStorage mockStorage;
    late ChatCacheService service;
    late MockRef mockRef;

    const chatRoomId = 'room_123';
    late StorageChat sampleMessage;

    setUp(() {
      final now = DateTime.now();
      sampleMessage = StorageChat(
        id: '1',
        message: 'Hello',
        createdAt: now,
        createdBy: 'user1',
      );

      mockStorage = MockJsonStorage();
      mockRef = MockRef();

      // 디버깅: 어떤 provider가 호출되는지 확인
      when(() => mockRef.read(any())).thenAnswer((invocation) {
        print(
            'Provider called: ${invocation.positionalArguments[0].runtimeType}');
        print('Provider toString: ${invocation.positionalArguments[0]}');
        return mockStorage;
      });
    });

    test('Provider 호출 디버깅', () async {
      when(() => mockStorage.init()).thenAnswer((_) async {});
      when(() => mockStorage.load(chatRoomId))
          .thenAnswer((_) async => [sampleMessage]);

      try {
        service = ChatCacheService(chatRoomId: chatRoomId, ref: mockRef);
        await Future.delayed(const Duration(milliseconds: 100));

        expect(service.messages.length, 1);
      } catch (e) {
        print('Error occurred: $e');
        rethrow;
      }
    });
  });
}

// // 또는 더 직접적인 접근 방법
// void alternativeMain() {
//   group('ChatCacheService Alternative', () {
//     test('의존성 주입을 통한 테스트', () async {
//       // ChatCacheService가 JsonStorageInterface를 직접 받을 수 있다면
//       final mockStorage = MockJsonStorage();

//       when(() => mockStorage.init()).thenAnswer((_) async {});
//       when(() => mockStorage.load('room_123')).thenAnswer((_) async => []);

//       // 직접 storage를 주입하는 방식으로 서비스 생성
//       final service = ChatCacheService.withStorage(
//         chatRoomId: 'room_123',
//         storage: mockStorage,
//       );

//       await Future.delayed(const Duration(milliseconds: 100));

//       expect(service.messages, isEmpty);
//       verify(() => mockStorage.init()).called(1);
//     });
//   });
// }

// // Provider 타입이 확실하지 않은 경우를 위한 범용적 접근
// void universalMain() {
//   group('ChatCacheService Universal', () {
//     late MockJsonStorage mockStorage;
//     late MockRef mockRef;

//     setUp(() {
//       mockStorage = MockJsonStorage();
//       mockRef = MockRef();

//       // 모든 가능한 Provider 타입에 대해 모킹
//       when(() => mockRef.read<JsonStorageInterface<List<StorageChat>>>(any()))
//           .thenReturn(mockStorage);
//       when(() => mockRef.read<JsonStorage<List<StorageChat>>>(any()))
//           .thenReturn(mockStorage as dynamic);
//       when(() => mockRef.read<dynamic>(any())).thenReturn(mockStorage);
//       when(() => mockRef.read(any())).thenReturn(mockStorage);
//     });

//     test('범용 모킹 테스트', () async {
//       when(() => mockStorage.init()).thenAnswer((_) async {});
//       when(() => mockStorage.load('room_123')).thenAnswer((_) async => []);

//       final service = ChatCacheService(chatRoomId: 'room_123', ref: mockRef);
//       await Future.delayed(const Duration(milliseconds: 100));

//       expect(service.messages, isEmpty);
//     });
//   });
// }
