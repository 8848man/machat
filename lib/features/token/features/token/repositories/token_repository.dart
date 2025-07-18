import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/token/features/token/models/lib.dart';
import '../interfaces/token_service.dart';

/// 토큰 서비스
/// 사용법
/// 하단의 tokenServiceProvider처럼 앱 내부 Firestore 인스턴스를 주입하여 사용

final tokenServiceProvider = Provider<ITokenService>((ref) {
  final firestore = FirebaseFirestore.instance;
  return FirebaseTokenService(firestore: firestore);
});

/// Firebase 기반 토큰 서비스 구현체
class FirebaseTokenService implements ITokenService {
  final FirebaseFirestore _firestore;

  static const String _tokenCollection = 'token';
  static const String _tokenLogCollection = 'token_log';

  FirebaseTokenService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<TokenModel> watchUserToken(String userId) {
    final docRef = _firestore.collection(_tokenCollection).doc(userId);

    return docRef.snapshots().asyncMap((doc) async {
      if (doc.exists) {
        return TokenModel.fromFirestore(doc);
      }

      // 문서가 없을 경우 초기화 후 리턴
      final now = DateTime.now();
      final newToken = TokenModel(
        userId: userId,
        currentTokens: 0,
        totalEarnedTokens: 0,
        totalSpentTokens: 0,
        lastDailyReward: now.subtract(const Duration(days: 2)),
        createdAt: now,
        updatedAt: now,
      );

      await docRef.set(newToken.toFirestore());

      return newToken;
    });
  }

  @override
  Future<TokenModel> getUserToken(String userId) async {
    try {
      final tokenRef = _firestore.collection(_tokenCollection).doc(userId);

      return await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(tokenRef);

        if (snapshot.exists) {
          return TokenModel.fromFirestore(snapshot);
        }

        // 문서가 없을 경우, 초기화
        final now = DateTime.now();
        final newToken = TokenModel(
          userId: userId,
          currentTokens: 0,
          totalEarnedTokens: 0,
          totalSpentTokens: 0,
          lastDailyReward: now.subtract(const Duration(days: 2)),
          createdAt: now,
          updatedAt: now,
        );

        transaction.set(tokenRef, newToken.toFirestore());
        return newToken;
      });
    } catch (e) {
      throw Exception('Failed to get or create user token in transaction: $e');
    }
  }

  @override
  Future<int> getUserTokenBalance(String userId) async {
    try {
      final token = await getUserToken(userId);
      return token.currentTokens;
    } catch (e) {
      throw Exception('Failed to get user token balance: $e');
    }
  }

  @override
  Future<void> addTokens(String userId, int amount,
      {String? description}) async {
    try {
      final tokenRef = _firestore.collection(_tokenCollection).doc(userId);

      await _firestore.runTransaction((transaction) async {
        final tokenDoc = await transaction.get(tokenRef);

        TokenModel currentToken;
        if (tokenDoc.exists) {
          currentToken = TokenModel.fromFirestore(tokenDoc);
        } else {
          currentToken = TokenModel(
            userId: userId,
            lastDailyReward: DateTime.now().subtract(const Duration(days: 2)),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        }

        final updatedToken = currentToken.copyWith(
          currentTokens: currentToken.currentTokens + amount,
          totalEarnedTokens: currentToken.totalEarnedTokens + amount,
          updatedAt: DateTime.now(),
        );

        transaction.set(tokenRef, updatedToken.toFirestore());

        // 로그 생성
        final logRef = _firestore.collection(_tokenLogCollection).doc();
        final log = TokenLogModel(
          id: logRef.id,
          userId: userId,
          type: TokenLogType.bonus,
          amount: amount,
          balanceBefore: currentToken.currentTokens,
          balanceAfter: updatedToken.currentTokens,
          description: description ?? '토큰 추가',
          createdAt: DateTime.now(),
        );
        transaction.set(logRef, log.toFirestore());
      });
    } catch (e) {
      throw Exception('Failed to add tokens: $e');
    }
  }

  @override
  Future<bool> spendTokens(String userId, int amount,
      {String? description}) async {
    try {
      final tokenRef = _firestore.collection(_tokenCollection).doc(userId);

      final result = await _firestore.runTransaction<bool>((transaction) async {
        final tokenDoc = await transaction.get(tokenRef);

        if (!tokenDoc.exists) {
          throw Exception('User token not found');
        }

        final currentToken = TokenModel.fromFirestore(tokenDoc);

        if (currentToken.currentTokens < amount) {
          return false;
        }

        final updatedToken = currentToken.copyWith(
          currentTokens: currentToken.currentTokens - amount,
          totalSpentTokens: currentToken.totalSpentTokens + amount,
          updatedAt: DateTime.now(),
        );

        transaction.set(tokenRef, updatedToken.toFirestore());

        // 로그 생성
        final logRef = _firestore.collection(_tokenLogCollection).doc();
        final log = TokenLogModel(
          id: logRef.id,
          userId: userId,
          type: TokenLogType.usage,
          amount: -amount,
          balanceBefore: currentToken.currentTokens,
          balanceAfter: updatedToken.currentTokens,
          description: description ?? '토큰 사용',
          createdAt: DateTime.now(),
        );
        transaction.set(logRef, log.toFirestore());

        return true;
      });

      return result;
    } catch (e) {
      throw Exception('Failed to spend tokens: $e');
    }
  }

  @override
  Future<bool> giveDailyReward(String userId, {int rewardAmount = 10}) async {
    try {
      final tokenRef = _firestore.collection(_tokenCollection).doc(userId);

      final result = await _firestore.runTransaction<bool>((transaction) async {
        final tokenDoc = await transaction.get(tokenRef);

        TokenModel currentToken;
        if (tokenDoc.exists) {
          currentToken = TokenModel.fromFirestore(tokenDoc);
        } else {
          currentToken = TokenModel(
            userId: userId,
            lastDailyReward: DateTime.now().subtract(const Duration(days: 2)),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        }

        if (!currentToken.canReceiveDailyReward()) {
          return false;
        }

        final updatedToken = currentToken.copyWith(
          currentTokens: currentToken.currentTokens + rewardAmount,
          totalEarnedTokens: currentToken.totalEarnedTokens + rewardAmount,
          lastDailyReward: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        transaction.set(tokenRef, updatedToken.toFirestore());

        // 로그 생성
        final logRef = _firestore.collection(_tokenLogCollection).doc();
        final log = TokenLogModel(
          id: logRef.id,
          userId: userId,
          type: TokenLogType.dailyReward,
          amount: rewardAmount,
          balanceBefore: currentToken.currentTokens,
          balanceAfter: updatedToken.currentTokens,
          description: '일일 보상',
          createdAt: DateTime.now(),
        );
        transaction.set(logRef, log.toFirestore());

        return true;
      });

      return result;
    } catch (e) {
      throw Exception('Failed to give daily reward: $e');
    }
  }

  @override
  Future<void> purchaseTokens(String userId, int amount, double price,
      {String? transactionId}) async {
    try {
      final tokenRef = _firestore.collection(_tokenCollection).doc(userId);

      await _firestore.runTransaction((transaction) async {
        final tokenDoc = await transaction.get(tokenRef);

        TokenModel currentToken;
        if (tokenDoc.exists) {
          currentToken = TokenModel.fromFirestore(tokenDoc);
        } else {
          currentToken = TokenModel(
            userId: userId,
            lastDailyReward: DateTime.now().subtract(const Duration(days: 2)),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        }

        final updatedToken = currentToken.copyWith(
          currentTokens: currentToken.currentTokens + amount,
          totalEarnedTokens: currentToken.totalEarnedTokens + amount,
          updatedAt: DateTime.now(),
        );

        transaction.set(tokenRef, updatedToken.toFirestore());

        // 로그 생성
        final logRef = _firestore.collection(_tokenLogCollection).doc();
        final log = TokenLogModel(
          id: logRef.id,
          userId: userId,
          type: TokenLogType.purchase,
          amount: amount,
          balanceBefore: currentToken.currentTokens,
          balanceAfter: updatedToken.currentTokens,
          description: '토큰 구매',
          metadata: {
            'price': price,
            'transactionId': transactionId,
          },
          createdAt: DateTime.now(),
        );
        transaction.set(logRef, log.toFirestore());
      });
    } catch (e) {
      throw Exception('Failed to purchase tokens: $e');
    }
  }

  @override
  Future<List<TokenLogModel>> getUserTokenLogs(String userId,
      {int limit = 50}) async {
    try {
      final querySnapshot = await _firestore
          .collection(_tokenLogCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => TokenLogModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user token logs: $e');
    }
  }

  @override
  Future<List<TokenLogModel>> getLogsByType(
      String userId, TokenLogType type) async {
    try {
      final querySnapshot = await _firestore
          .collection(_tokenLogCollection)
          .where('userId', isEqualTo: userId)
          .where('type', isEqualTo: type.name)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => TokenLogModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get logs by type: $e');
    }
  }

  @override
  Future<List<TokenLogModel>> getLogsByDays(String userId, int days) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: days));
      final querySnapshot = await _firestore
          .collection(_tokenLogCollection)
          .where('userId', isEqualTo: userId)
          .where('createdAt', isGreaterThan: Timestamp.fromDate(cutoffDate))
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => TokenLogModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get logs by days: $e');
    }
  }
}
