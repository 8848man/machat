import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:machat/features/token/repositories/token_repository.dart';
import 'package:machat/features/token/models/token_log_model.dart';

import 'token_repository_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference<Map<String, dynamic>>,
  DocumentReference<Map<String, dynamic>>,
  DocumentSnapshot<Map<String, dynamic>>,
  QuerySnapshot<Map<String, dynamic>>,
  Query<Map<String, dynamic>>,
  WriteBatch,
  Transaction
])
void main() {
  group('FirebaseTokenService', () {
    late FirebaseTokenService tokenService;
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference<Map<String, dynamic>> mockTokenCollection;
    late MockCollectionReference<Map<String, dynamic>> mockLogCollection;
    late MockDocumentReference<Map<String, dynamic>> mockTokenDoc;
    late MockDocumentReference<Map<String, dynamic>> mockLogDoc;
    late MockTransaction mockTransaction;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockTokenCollection = MockCollectionReference();
      mockLogCollection = MockCollectionReference();
      mockTokenDoc = MockDocumentReference();
      mockLogDoc = MockDocumentReference();
      mockTransaction = MockTransaction();

      when(mockFirestore.collection('token')).thenReturn(mockTokenCollection);
      when(mockFirestore.collection('token_log')).thenReturn(mockLogCollection);
      when(mockTokenCollection.doc(any)).thenReturn(mockTokenDoc);
      when(mockLogCollection.doc()).thenReturn(mockLogDoc);

      tokenService = FirebaseTokenService(firestore: mockFirestore);
    });

    group('getUserToken', () {
      test('should return TokenModel when document exists', () async {
        final mockData = {
          'currentTokens': 100,
          'totalEarnedTokens': 500,
          'totalSpentTokens': 400,
          'lastDailyReward': Timestamp.fromDate(DateTime(2024, 1, 1)),
          'createdAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
          'updatedAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
        };

        final mockDoc = MockDocumentSnapshot<Map<String, dynamic>>();
        when(mockDoc.exists).thenReturn(true);
        when(mockDoc.data()).thenReturn(mockData);
        when(mockDoc.id).thenReturn('user_123');
        when(mockTokenDoc.get()).thenAnswer((_) async => mockDoc);

        final result = await tokenService.getUserToken('user_123');

        expect(result, isNotNull);
        expect(result!.userId, 'user_123');
        expect(result.currentTokens, 100);
        expect(result.totalEarnedTokens, 500);
        expect(result.totalSpentTokens, 400);
      });

      test('should return null when document does not exist', () async {
        final mockDoc = MockDocumentSnapshot<Map<String, dynamic>>();
        when(mockDoc.exists).thenReturn(false);
        when(mockTokenDoc.get()).thenAnswer((_) async => mockDoc);

        final result = await tokenService.getUserToken('user_123');

        expect(result, isNull);
      });

      test('should throw exception on error', () async {
        when(mockTokenDoc.get()).thenThrow(Exception('Firebase error'));

        expect(
          () => tokenService.getUserToken('user_123'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getUserTokenBalance', () {
      test('should return token balance', () async {
        final mockData = {
          'currentTokens': 150,
          'totalEarnedTokens': 500,
          'totalSpentTokens': 350,
          'lastDailyReward': Timestamp.fromDate(DateTime(2024, 1, 1)),
          'createdAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
          'updatedAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
        };

        final mockDoc = MockDocumentSnapshot<Map<String, dynamic>>();
        when(mockDoc.exists).thenReturn(true);
        when(mockDoc.data()).thenReturn(mockData);
        when(mockDoc.id).thenReturn('user_123');
        when(mockTokenDoc.get()).thenAnswer((_) async => mockDoc);

        final result = await tokenService.getUserTokenBalance('user_123');

        expect(result, 150);
      });

      test('should return 0 when user has no tokens', () async {
        final mockDoc = MockDocumentSnapshot<Map<String, dynamic>>();
        when(mockDoc.exists).thenReturn(false);
        when(mockTokenDoc.get()).thenAnswer((_) async => mockDoc);

        final result = await tokenService.getUserTokenBalance('user_123');

        expect(result, 0);
      });
    });

    group('addTokens', () {
      test('should add tokens to existing user', () async {
        final existingTokenData = {
          'currentTokens': 100,
          'totalEarnedTokens': 500,
          'totalSpentTokens': 400,
          'lastDailyReward': Timestamp.fromDate(DateTime(2024, 1, 1)),
          'createdAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
          'updatedAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
        };

        final mockDoc = MockDocumentSnapshot<Map<String, dynamic>>();
        when(mockDoc.exists).thenReturn(true);
        when(mockDoc.data()).thenReturn(existingTokenData);
        when(mockDoc.id).thenReturn('user_123');

        when(mockFirestore.runTransaction(any)).thenAnswer((invocation) async {
          final callback =
              invocation.positionalArguments[0] as Function(Transaction);
          await callback(mockTransaction);
        });

        when(mockTransaction.get(mockTokenDoc))
            .thenAnswer((_) async => mockDoc);
        when(mockTransaction.set(any, any)).thenReturn(mockTransaction);

        await tokenService.addTokens('user_123', 50, description: '테스트 추가');

        verify(mockTransaction.set(mockTokenDoc, any)).called(1);
        verify(mockTransaction.set(mockLogDoc, any)).called(1);
      });

      test('should create new user token when user does not exist', () async {
        final mockDoc = MockDocumentSnapshot<Map<String, dynamic>>();
        when(mockDoc.exists).thenReturn(false);

        when(mockFirestore.runTransaction(any)).thenAnswer((invocation) async {
          final callback =
              invocation.positionalArguments[0] as Function(Transaction);
          await callback(mockTransaction);
        });

        when(mockTransaction.get(mockTokenDoc))
            .thenAnswer((_) async => mockDoc);
        when(mockTransaction.set(any, any)).thenReturn(mockTransaction);

        await tokenService.addTokens('new_user', 100, description: '신규 사용자');

        verify(mockTransaction.set(mockTokenDoc, any)).called(1);
        verify(mockTransaction.set(mockLogDoc, any)).called(1);
      });
    });

    group('spendTokens', () {
      test('should spend tokens successfully', () async {
        final existingTokenData = {
          'currentTokens': 100,
          'totalEarnedTokens': 500,
          'totalSpentTokens': 400,
          'lastDailyReward': Timestamp.fromDate(DateTime(2024, 1, 1)),
          'createdAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
          'updatedAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
        };

        final mockDoc = MockDocumentSnapshot<Map<String, dynamic>>();
        when(mockDoc.exists).thenReturn(true);
        when(mockDoc.data()).thenReturn(existingTokenData);
        when(mockDoc.id).thenReturn('user_123');

        when(mockFirestore.runTransaction(any)).thenAnswer((invocation) async {
          final callback =
              invocation.positionalArguments[0] as Function(Transaction);
          return await callback(mockTransaction);
        });

        when(mockTransaction.get(mockTokenDoc))
            .thenAnswer((_) async => mockDoc);
        when(mockTransaction.set(any, any)).thenReturn(mockTransaction);

        final result = await tokenService.spendTokens('user_123', 30,
            description: '테스트 사용');

        expect(result, true);
        verify(mockTransaction.set(mockTokenDoc, any)).called(1);
        verify(mockTransaction.set(mockLogDoc, any)).called(1);
      });

      test('should return false when insufficient tokens', () async {
        final existingTokenData = {
          'currentTokens': 20,
          'totalEarnedTokens': 500,
          'totalSpentTokens': 480,
          'lastDailyReward': Timestamp.fromDate(DateTime(2024, 1, 1)),
          'createdAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
          'updatedAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
        };

        final mockDoc = MockDocumentSnapshot<Map<String, dynamic>>();
        when(mockDoc.exists).thenReturn(true);
        when(mockDoc.data()).thenReturn(existingTokenData);
        when(mockDoc.id).thenReturn('user_123');

        when(mockFirestore.runTransaction(any)).thenAnswer((invocation) async {
          final callback =
              invocation.positionalArguments[0] as Function(Transaction);
          return await callback(mockTransaction);
        });

        when(mockTransaction.get(mockTokenDoc))
            .thenAnswer((_) async => mockDoc);

        final result = await tokenService.spendTokens('user_123', 50,
            description: '부족한 토큰');

        expect(result, false);
        verifyNever(mockTransaction.set(any, any));
      });

      test('should throw exception when user token not found', () async {
        final mockDoc = MockDocumentSnapshot<Map<String, dynamic>>();
        when(mockDoc.exists).thenReturn(false);

        when(mockFirestore.runTransaction(any)).thenAnswer((invocation) async {
          final callback =
              invocation.positionalArguments[0] as Function(Transaction);
          return await callback(mockTransaction);
        });

        when(mockTransaction.get(mockTokenDoc))
            .thenAnswer((_) async => mockDoc);

        expect(
          () => tokenService.spendTokens('user_123', 50),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('giveDailyReward', () {
      test('should give daily reward successfully', () async {
        final existingTokenData = {
          'currentTokens': 100,
          'totalEarnedTokens': 500,
          'totalSpentTokens': 400,
          'lastDailyReward': Timestamp.fromDate(
              DateTime.now().subtract(const Duration(days: 1))),
          'createdAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
          'updatedAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
        };

        final mockDoc = MockDocumentSnapshot<Map<String, dynamic>>();
        when(mockDoc.exists).thenReturn(true);
        when(mockDoc.data()).thenReturn(existingTokenData);
        when(mockDoc.id).thenReturn('user_123');

        when(mockFirestore.runTransaction(any)).thenAnswer((invocation) async {
          final callback =
              invocation.positionalArguments[0] as Function(Transaction);
          return await callback(mockTransaction);
        });

        when(mockTransaction.get(mockTokenDoc))
            .thenAnswer((_) async => mockDoc);
        when(mockTransaction.set(any, any)).thenReturn(mockTransaction);

        final result =
            await tokenService.giveDailyReward('user_123', rewardAmount: 10);

        expect(result, true);
        verify(mockTransaction.set(mockTokenDoc, any)).called(1);
        verify(mockTransaction.set(mockLogDoc, any)).called(1);
      });

      test('should return false when already received today', () async {
        final existingTokenData = {
          'currentTokens': 100,
          'totalEarnedTokens': 500,
          'totalSpentTokens': 400,
          'lastDailyReward': Timestamp.fromDate(DateTime.now()),
          'createdAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
          'updatedAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
        };

        final mockDoc = MockDocumentSnapshot<Map<String, dynamic>>();
        when(mockDoc.exists).thenReturn(true);
        when(mockDoc.data()).thenReturn(existingTokenData);
        when(mockDoc.id).thenReturn('user_123');

        when(mockFirestore.runTransaction(any)).thenAnswer((invocation) async {
          final callback =
              invocation.positionalArguments[0] as Function(Transaction);
          return await callback(mockTransaction);
        });

        when(mockTransaction.get(mockTokenDoc))
            .thenAnswer((_) async => mockDoc);

        final result = await tokenService.giveDailyReward('user_123');

        expect(result, false);
        verifyNever(mockTransaction.set(any, any));
      });
    });

    group('getUserTokenLogs', () {
      test('should return list of token logs', () async {
        final mockLogs = [
          {
            'userId': 'user_123',
            'type': 'dailyReward',
            'amount': 10,
            'balanceBefore': 90,
            'balanceAfter': 100,
            'description': '일일 보상',
            'createdAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
          },
          {
            'userId': 'user_123',
            'type': 'usage',
            'amount': -5,
            'balanceBefore': 100,
            'balanceAfter': 95,
            'description': '토큰 사용',
            'createdAt': Timestamp.fromDate(DateTime(2024, 1, 2)),
          },
        ];

        final mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
        final mockDocs = mockLogs.map((data) {
          final mockDoc = MockDocumentSnapshot<Map<String, dynamic>>();
          when(mockDoc.id).thenReturn('log_${mockLogs.indexOf(data)}');
          when(mockDoc.data()).thenReturn(data);
          return mockDoc as QueryDocumentSnapshot<Map<String, dynamic>>;
        }).toList();

        when(mockLogCollection.where('userId', isEqualTo: 'user_123'))
            .thenReturn(mockLogCollection);
        when(mockLogCollection.orderBy('createdAt', descending: true))
            .thenReturn(mockLogCollection);
        when(mockLogCollection.limit(50)).thenReturn(mockLogCollection);
        when(mockLogCollection.get())
            .thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn(mockDocs);

        final result = await tokenService.getUserTokenLogs('user_123');

        expect(result, hasLength(2));
        expect(result[0].type, TokenLogType.dailyReward);
        expect(result[1].type, TokenLogType.usage);
      });
    });
  });
}
