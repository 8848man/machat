import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:machat/features/token/models/token_model.dart';

void main() {
  group('TokenModel', () {
    test('should create TokenModel with default values', () {
      final token = TokenModel(
        userId: 'test_user',
        lastDailyReward: DateTime(2024, 1, 1),
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      expect(token.userId, 'test_user');
      expect(token.currentTokens, 0);
      expect(token.totalEarnedTokens, 0);
      expect(token.totalSpentTokens, 0);
      expect(token.lastDailyReward, DateTime(2024, 1, 1));
    });

    test('should create TokenModel with custom values', () {
      final token = TokenModel(
        userId: 'test_user',
        currentTokens: 100,
        totalEarnedTokens: 500,
        totalSpentTokens: 400,
        lastDailyReward: DateTime(2024, 1, 1),
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      expect(token.currentTokens, 100);
      expect(token.totalEarnedTokens, 500);
      expect(token.totalSpentTokens, 400);
    });

    test('should create TokenModel from Firestore document', () {
      final mockData = {
        'currentTokens': 100,
        'totalEarnedTokens': 500,
        'totalSpentTokens': 400,
        'lastDailyReward': Timestamp.fromDate(DateTime(2024, 1, 1)),
        'createdAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
        'updatedAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
      };

      final mockDoc = MockDocumentSnapshot('test_user', mockData);
      final token = TokenModel.fromFirestore(mockDoc);

      expect(token.userId, 'test_user');
      expect(token.currentTokens, 100);
      expect(token.totalEarnedTokens, 500);
      expect(token.totalSpentTokens, 400);
    });

    test('should convert to Firestore format', () {
      final token = TokenModel(
        userId: 'test_user',
        currentTokens: 100,
        totalEarnedTokens: 500,
        totalSpentTokens: 400,
        lastDailyReward: DateTime(2024, 1, 1),
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      final firestoreData = token.toFirestore();

      expect(firestoreData['currentTokens'], 100);
      expect(firestoreData['totalEarnedTokens'], 500);
      expect(firestoreData['totalSpentTokens'], 400);
      expect(firestoreData['lastDailyReward'], isA<Timestamp>());
    });

    test('should check if daily reward can be received', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final today = DateTime.now();
      final tomorrow = DateTime.now().add(const Duration(days: 1));

      final tokenYesterday = TokenModel(
        userId: 'test_user',
        lastDailyReward: yesterday,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      final tokenToday = TokenModel(
        userId: 'test_user',
        lastDailyReward: today,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      expect(tokenYesterday.canReceiveDailyReward(), true);
      expect(tokenToday.canReceiveDailyReward(), false);
    });

    test('should create copy with updated values', () {
      final original = TokenModel(
        userId: 'test_user',
        currentTokens: 100,
        totalEarnedTokens: 500,
        totalSpentTokens: 400,
        lastDailyReward: DateTime(2024, 1, 1),
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      final updated = original.copyWith(
        currentTokens: 200,
        totalEarnedTokens: 600,
      );

      expect(updated.currentTokens, 200);
      expect(updated.totalEarnedTokens, 600);
      expect(updated.totalSpentTokens, 400); // unchanged
      expect(updated.userId, 'test_user'); // unchanged
    });
  });
}

// Mock DocumentSnapshot for testing
// ignore: subtype_of_sealed_class
class MockDocumentSnapshot implements DocumentSnapshot {
  @override
  final String id;
  final Map<String, dynamic> _mockData;

  MockDocumentSnapshot(this.id, this._mockData);

  @override
  bool get exists => true;

  @override
  Map<String, dynamic> data() => _mockData;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
