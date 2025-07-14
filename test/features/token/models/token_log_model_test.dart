import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:machat/features/token/models/token_log_model.dart';

void main() {
  group('TokenLogModel', () {
    test('should create TokenLogModel with required fields', () {
      final log = TokenLogModel(
        id: 'log_123',
        userId: 'user_123',
        type: TokenLogType.dailyReward,
        amount: 10,
        balanceBefore: 90,
        balanceAfter: 100,
        createdAt: DateTime(2024, 1, 1),
      );

      expect(log.id, 'log_123');
      expect(log.userId, 'user_123');
      expect(log.type, TokenLogType.dailyReward);
      expect(log.amount, 10);
      expect(log.balanceBefore, 90);
      expect(log.balanceAfter, 100);
    });

    test('should create TokenLogModel with optional fields', () {
      final log = TokenLogModel(
        id: 'log_123',
        userId: 'user_123',
        type: TokenLogType.purchase,
        amount: 100,
        balanceBefore: 0,
        balanceAfter: 100,
        description: '토큰 구매',
        metadata: {'price': 10000, 'transactionId': 'tx_123'},
        createdAt: DateTime(2024, 1, 1),
      );

      expect(log.description, '토큰 구매');
      expect(log.metadata!['price'], 10000);
      expect(log.metadata!['transactionId'], 'tx_123');
    });

    test('should create TokenLogModel from Firestore document', () {
      final mockData = {
        'userId': 'user_123',
        'type': 'dailyReward',
        'amount': 10,
        'balanceBefore': 90,
        'balanceAfter': 100,
        'description': '일일 보상',
        'metadata': {'source': 'daily'},
        'createdAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
      };

      final mockDoc = MockDocumentSnapshot('log_123', mockData);
      final log = TokenLogModel.fromFirestore(mockDoc);

      expect(log.id, 'log_123');
      expect(log.userId, 'user_123');
      expect(log.type, TokenLogType.dailyReward);
      expect(log.amount, 10);
      expect(log.description, '일일 보상');
      expect(log.metadata!['source'], 'daily');
    });

    test('should convert to Firestore format', () {
      final log = TokenLogModel(
        id: 'log_123',
        userId: 'user_123',
        type: TokenLogType.purchase,
        amount: 100,
        balanceBefore: 0,
        balanceAfter: 100,
        description: '토큰 구매',
        metadata: {'price': 10000},
        createdAt: DateTime(2024, 1, 1),
      );

      final firestoreData = log.toFirestore();

      expect(firestoreData['userId'], 'user_123');
      expect(firestoreData['type'], 'purchase');
      expect(firestoreData['amount'], 100);
      expect(firestoreData['description'], '토큰 구매');
      expect(firestoreData['metadata']['price'], 10000);
      expect(firestoreData['createdAt'], isA<Timestamp>());
    });

    test('should display correct description for each type', () {
      final dailyReward = TokenLogModel(
        id: '1',
        userId: 'user',
        type: TokenLogType.dailyReward,
        amount: 10,
        balanceBefore: 0,
        balanceAfter: 10,
        createdAt: DateTime.now(),
      );

      final purchase = TokenLogModel(
        id: '2',
        userId: 'user',
        type: TokenLogType.purchase,
        amount: 100,
        balanceBefore: 0,
        balanceAfter: 100,
        createdAt: DateTime.now(),
      );

      final usage = TokenLogModel(
        id: '3',
        userId: 'user',
        type: TokenLogType.usage,
        amount: -10,
        balanceBefore: 100,
        balanceAfter: 90,
        createdAt: DateTime.now(),
      );

      expect(dailyReward.displayDescription, '일일 보상');
      expect(purchase.displayDescription, '토큰 구매');
      expect(usage.displayDescription, '토큰 사용');
    });

    test('should display correct amount format', () {
      final positiveLog = TokenLogModel(
        id: '1',
        userId: 'user',
        type: TokenLogType.dailyReward,
        amount: 10,
        balanceBefore: 0,
        balanceAfter: 10,
        createdAt: DateTime.now(),
      );

      final negativeLog = TokenLogModel(
        id: '2',
        userId: 'user',
        type: TokenLogType.usage,
        amount: -10,
        balanceBefore: 100,
        balanceAfter: 90,
        createdAt: DateTime.now(),
      );

      expect(positiveLog.displayAmount, '+10');
      expect(negativeLog.displayAmount, '-10');
    });

    test('should create copy with updated values', () {
      final original = TokenLogModel(
        id: 'log_123',
        userId: 'user_123',
        type: TokenLogType.dailyReward,
        amount: 10,
        balanceBefore: 90,
        balanceAfter: 100,
        description: '일일 보상',
        createdAt: DateTime(2024, 1, 1),
      );

      final updated = original.copyWith(
        amount: 20,
        balanceAfter: 110,
        description: '수정된 보상',
      );

      expect(updated.amount, 20);
      expect(updated.balanceAfter, 110);
      expect(updated.description, '수정된 보상');
      expect(updated.balanceBefore, 90); // unchanged
      expect(updated.type, TokenLogType.dailyReward); // unchanged
    });

    test('should handle unknown log type gracefully', () {
      final mockData = {
        'userId': 'user_123',
        'type': 'unknownType',
        'amount': 10,
        'balanceBefore': 0,
        'balanceAfter': 10,
        'createdAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
      };

      final mockDoc = MockDocumentSnapshot('log_123', mockData);
      final log = TokenLogModel.fromFirestore(mockDoc);

      expect(log.type, TokenLogType.usage); // default fallback
    });
  });
}

// Mock DocumentSnapshot for testing
// ignore: subtype_of_sealed_class
class MockDocumentSnapshot implements DocumentSnapshot {
  @override
  final String id;
  final Map<String, dynamic> _data;

  MockDocumentSnapshot(this.id, this._data);

  @override
  bool get exists => true;

  @override
  Map<String, dynamic> data() => _data;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
