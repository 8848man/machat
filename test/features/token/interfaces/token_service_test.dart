import 'package:flutter_test/flutter_test.dart';
import 'package:machat/features/token/interfaces/token_service.dart';
import 'package:machat/features/token/models/token_model.dart';
import 'package:machat/features/token/models/token_log_model.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('TokenService Interface', () {
    late MockTokenService mockTokenService;

    setUp(() {
      mockTokenService = MockTokenService();
    });

    group('getUserToken', () {
      test('should return TokenModel when user exists', () async {
        final mockToken = TokenModel(
          userId: 'user_123',
          currentTokens: 100,
          totalEarnedTokens: 500,
          totalSpentTokens: 400,
          lastDailyReward: DateTime(2024, 1, 1),
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );

        when(mockTokenService.getUserToken('user_123'))
            .thenAnswer((_) async => mockToken);

        final result = await mockTokenService.getUserToken('user_123');

        expect(result, isNotNull);
        expect(result!.userId, 'user_123');
        expect(result.currentTokens, 100);
      });

      test('should return null when user does not exist', () async {
        when(mockTokenService.getUserToken('nonexistent'))
            .thenAnswer((_) async => null);

        final result = await mockTokenService.getUserToken('nonexistent');

        expect(result, isNull);
      });
    });

    group('getUserTokenBalance', () {
      test('should return token balance', () async {
        when(mockTokenService.getUserTokenBalance('user_123'))
            .thenAnswer((_) async => 150);

        final result = await mockTokenService.getUserTokenBalance('user_123');

        expect(result, 150);
      });

      test('should return 0 for new user', () async {
        when(mockTokenService.getUserTokenBalance('new_user'))
            .thenAnswer((_) async => 0);

        final result = await mockTokenService.getUserTokenBalance('new_user');

        expect(result, 0);
      });
    });

    group('addTokens', () {
      test('should add tokens successfully', () async {
        when(mockTokenService.addTokens('user_123', 50, description: '테스트 추가'))
            .thenAnswer((_) async {});

        await mockTokenService.addTokens('user_123', 50, description: '테스트 추가');

        verify(mockTokenService.addTokens('user_123', 50,
                description: '테스트 추가'))
            .called(1);
      });

      test('should handle negative amount', () async {
        when(mockTokenService.addTokens('user_123', -10, description: '음수 테스트'))
            .thenAnswer((_) async {});

        await mockTokenService.addTokens('user_123', -10,
            description: '음수 테스트');

        verify(mockTokenService.addTokens('user_123', -10,
                description: '음수 테스트'))
            .called(1);
      });
    });

    group('spendTokens', () {
      test('should spend tokens successfully', () async {
        when(mockTokenService.spendTokens('user_123', 30,
                description: '테스트 사용'))
            .thenAnswer((_) async => true);

        final result = await mockTokenService.spendTokens('user_123', 30,
            description: '테스트 사용');

        expect(result, true);
        verify(mockTokenService.spendTokens('user_123', 30,
                description: '테스트 사용'))
            .called(1);
      });

      test('should return false when insufficient tokens', () async {
        when(mockTokenService.spendTokens('user_123', 1000,
                description: '부족한 토큰'))
            .thenAnswer((_) async => false);

        final result = await mockTokenService.spendTokens('user_123', 1000,
            description: '부족한 토큰');

        expect(result, false);
      });
    });

    group('giveDailyReward', () {
      test('should give daily reward successfully', () async {
        when(mockTokenService.giveDailyReward('user_123', rewardAmount: 10))
            .thenAnswer((_) async => true);

        final result = await mockTokenService.giveDailyReward('user_123',
            rewardAmount: 10);

        expect(result, true);
        verify(mockTokenService.giveDailyReward('user_123', rewardAmount: 10))
            .called(1);
      });

      test('should return false when already received today', () async {
        when(mockTokenService.giveDailyReward('user_123'))
            .thenAnswer((_) async => false);

        final result = await mockTokenService.giveDailyReward('user_123');

        expect(result, false);
      });
    });

    group('purchaseTokens', () {
      test('should purchase tokens successfully', () async {
        when(mockTokenService.purchaseTokens('user_123', 1000, 10000,
                transactionId: 'tx_123'))
            .thenAnswer((_) async {});

        await mockTokenService.purchaseTokens('user_123', 1000, 10000,
            transactionId: 'tx_123');

        verify(mockTokenService.purchaseTokens('user_123', 1000, 10000,
                transactionId: 'tx_123'))
            .called(1);
      });

      test('should handle purchase without transaction ID', () async {
        when(mockTokenService.purchaseTokens('user_123', 1000, 10000))
            .thenAnswer((_) async {});

        await mockTokenService.purchaseTokens('user_123', 1000, 10000);

        verify(mockTokenService.purchaseTokens('user_123', 1000, 10000))
            .called(1);
      });
    });

    group('getUserTokenLogs', () {
      test('should return list of token logs', () async {
        final mockLogs = [
          TokenLogModel(
            id: 'log_1',
            userId: 'user_123',
            type: TokenLogType.dailyReward,
            amount: 10,
            balanceBefore: 90,
            balanceAfter: 100,
            createdAt: DateTime(2024, 1, 1),
          ),
          TokenLogModel(
            id: 'log_2',
            userId: 'user_123',
            type: TokenLogType.usage,
            amount: -5,
            balanceBefore: 100,
            balanceAfter: 95,
            createdAt: DateTime(2024, 1, 2),
          ),
        ];

        when(mockTokenService.getUserTokenLogs('user_123', limit: 50))
            .thenAnswer((_) async => mockLogs);

        final result =
            await mockTokenService.getUserTokenLogs('user_123', limit: 50);

        expect(result, hasLength(2));
        expect(result[0].type, TokenLogType.dailyReward);
        expect(result[1].type, TokenLogType.usage);
      });

      test('should return empty list when no logs exist', () async {
        when(mockTokenService.getUserTokenLogs('user_123'))
            .thenAnswer((_) async => []);

        final result = await mockTokenService.getUserTokenLogs('user_123');

        expect(result, isEmpty);
      });

      test('should respect limit parameter', () async {
        final mockLogs = List.generate(
            100,
            (index) => TokenLogModel(
                  id: 'log_$index',
                  userId: 'user_123',
                  type: TokenLogType.dailyReward,
                  amount: 10,
                  balanceBefore: 90,
                  balanceAfter: 100,
                  createdAt: DateTime(2024, 1, 1),
                ));

        when(mockTokenService.getUserTokenLogs('user_123', limit: 10))
            .thenAnswer((_) async => mockLogs.take(10).toList());

        final result =
            await mockTokenService.getUserTokenLogs('user_123', limit: 10);

        expect(result, hasLength(10));
      });
    });

    group('getUserTokenLogsByType', () {
      test('should return logs filtered by type', () async {
        final mockLogs = [
          TokenLogModel(
            id: 'log_1',
            userId: 'user_123',
            type: TokenLogType.dailyReward,
            amount: 10,
            balanceBefore: 90,
            balanceAfter: 100,
            createdAt: DateTime(2024, 1, 1),
          ),
        ];

        when(mockTokenService.getUserTokenLogsByType(
                'user_123', TokenLogType.dailyReward,
                limit: 50))
            .thenAnswer((_) async => mockLogs);

        final result = await mockTokenService.getUserTokenLogsByType(
            'user_123', TokenLogType.dailyReward,
            limit: 50);

        expect(result, hasLength(1));
        expect(result[0].type, TokenLogType.dailyReward);
      });
    });

    group('getUserTokenLogsByDateRange', () {
      test('should return logs within date range', () async {
        final startDate = DateTime(2024, 1, 1);
        final endDate = DateTime(2024, 1, 31);

        final mockLogs = [
          TokenLogModel(
            id: 'log_1',
            userId: 'user_123',
            type: TokenLogType.dailyReward,
            amount: 10,
            balanceBefore: 90,
            balanceAfter: 100,
            createdAt: DateTime(2024, 1, 15),
          ),
        ];

        when(mockTokenService.getUserTokenLogsByDateRange(
                'user_123', startDate, endDate,
                limit: 50))
            .thenAnswer((_) async => mockLogs);

        final result = await mockTokenService.getUserTokenLogsByDateRange(
            'user_123', startDate, endDate,
            limit: 50);

        expect(result, hasLength(1));
        expect(
            result[0]
                .createdAt
                .isAfter(startDate.subtract(const Duration(days: 1))),
            true);
        expect(
            result[0].createdAt.isBefore(endDate.add(const Duration(days: 1))),
            true);
      });
    });

    group('getUserTokenStats', () {
      test('should return token statistics', () async {
        final mockStats = {
          'totalEarned': 1000,
          'totalSpent': 500,
          'currentBalance': 500,
          'dailyRewardsReceived': 10,
          'purchasesMade': 2,
        };

        when(mockTokenService.getUserTokenStats('user_123'))
            .thenAnswer((_) async => mockStats);

        final result = await mockTokenService.getUserTokenStats('user_123');

        expect(result['totalEarned'], 1000);
        expect(result['totalSpent'], 500);
        expect(result['currentBalance'], 500);
        expect(result['dailyRewardsReceived'], 10);
        expect(result['purchasesMade'], 2);
      });
    });

    group('checkDailyRewardEligibility', () {
      test('should return true when eligible for daily reward', () async {
        when(mockTokenService.checkDailyRewardEligibility('user_123'))
            .thenAnswer((_) async => true);

        final result =
            await mockTokenService.checkDailyRewardEligibility('user_123');

        expect(result, true);
      });

      test('should return false when not eligible for daily reward', () async {
        when(mockTokenService.checkDailyRewardEligibility('user_123'))
            .thenAnswer((_) async => false);

        final result =
            await mockTokenService.checkDailyRewardEligibility('user_123');

        expect(result, false);
      });
    });

    group('getUserTokenHistory', () {
      test('should return token history', () async {
        final mockHistory = {
          'earned': [
            {'date': '2024-01-01', 'amount': 10, 'type': 'dailyReward'},
            {'date': '2024-01-02', 'amount': 100, 'type': 'purchase'},
          ],
          'spent': [
            {'date': '2024-01-03', 'amount': 5, 'type': 'usage'},
          ],
        };

        when(mockTokenService.getUserTokenHistory('user_123', days: 30))
            .thenAnswer((_) async => mockHistory);

        final result =
            await mockTokenService.getUserTokenHistory('user_123', days: 30);

        expect(result['earned'], hasLength(2));
        expect(result['spent'], hasLength(1));
      });
    });
  });
}

// Mock TokenService for testing
class MockTokenService implements TokenService {
  @override
  Future<TokenModel?> getUserToken(String userId) async {
    return null;
  }

  @override
  Future<int> getUserTokenBalance(String userId) async {
    return 0;
  }

  @override
  Future<void> addTokens(String userId, int amount,
      {String? description, Map<String, dynamic>? metadata}) async {}

  @override
  Future<bool> spendTokens(String userId, int amount,
      {String? description, Map<String, dynamic>? metadata}) async {
    return false;
  }

  @override
  Future<bool> giveDailyReward(String userId, {int rewardAmount = 10}) async {
    return false;
  }

  @override
  Future<void> purchaseTokens(String userId, int tokenAmount, double price,
      {String? transactionId, Map<String, dynamic>? metadata}) async {}

  @override
  Future<List<TokenLogModel>> getUserTokenLogs(String userId,
      {int limit = 50}) async {
    return [];
  }

  @override
  Future<List<TokenLogModel>> getUserTokenLogsByType(
      String userId, TokenLogType type,
      {int limit = 50}) async {
    return [];
  }

  @override
  Future<List<TokenLogModel>> getUserTokenLogsByDateRange(
      String userId, DateTime startDate, DateTime endDate,
      {int limit = 50}) async {
    return [];
  }

  @override
  Future<Map<String, dynamic>> getUserTokenStats(String userId) async {
    return {};
  }

  @override
  Future<bool> checkDailyRewardEligibility(String userId) async {
    return false;
  }

  @override
  Future<Map<String, dynamic>> getUserTokenHistory(String userId,
      {int days = 30}) async {
    return {};
  }

  @override
  Future<List<TokenLogModel>> getLogsByDays(String userId, int days) {
    // TODO: implement getLogsByDays
    throw UnimplementedError();
  }

  @override
  Future<List<TokenLogModel>> getLogsByType(String userId, TokenLogType type) {
    // TODO: implement getLogsByType
    throw UnimplementedError();
  }
}
