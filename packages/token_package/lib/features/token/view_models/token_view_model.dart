import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../providers/firebase_instance_provider.dart';
import '../models/lib.dart';
import '../interfaces/token_service.dart';
import '../providers/lib.dart';
import '../repositories/lib.dart';

part 'token_view_model.g.dart';

@riverpod
class TokenViewModel extends _$TokenViewModel {
  ITokenService get _tokenService => ref.read(tokenServiceProvider);
  @override
  Future<TokenStateModel> build() async {
    final user = ref.read(firebaseAuthProvider).currentUser;
    final uid = user?.uid;
    final TokenModel userToken =
        await ref.watch(tokenStreamProvider(uid ?? '').future);
    final List<TokenLogModel> tokenLogs = await loadUserTokenLogs(uid ?? '');
    return TokenStateModel(
      userToken: userToken,
      tokenLogs: tokenLogs,
    );
  }

  /// 사용자의 토큰 정보를 로드
  Future<TokenModel?> loadUserToken(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      return await _tokenService.getUserToken(userId);
    } catch (e) {
      print('error occured, $e');
      _setError('토큰 정보를 불러오는데 실패했습니다: $e');
    } finally {
      _setLoading(false);
    }
    return null;
  }

  /// 사용자의 토큰 로그를 로드
  Future<List<TokenLogModel>> loadUserTokenLogs(String userId,
      {int limit = 50}) async {
    _setLoading(true);
    _clearError();

    try {
      return await _tokenService.getUserTokenLogs(userId, limit: limit);
    } catch (e) {
      _setError('토큰 로그를 불러오는데 실패했습니다: $e');
    } finally {
      _setLoading(false);
    }

    return [];
  }

  /// 일일 보상 토큰 지급
  Future<bool> claimDailyReward({int rewardAmount = 10}) async {
    final user = ref.read(firebaseAuthProvider).currentUser;
    final uid = user?.uid;
    if (uid == null || uid == '') {
      return false;
    }
    final stateValue = state.value;
    if (stateValue == null) {
      return false;
    }
    if (stateValue.userToken == null) {
      return false;
    }
    stateValue.userToken!.canReceiveDailyReward();
    if (!stateValue.userToken!.canReceiveDailyReward()) {
      _setError('오늘은 이미 보상을 받았습니다.');
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      final success =
          await _tokenService.giveDailyReward(uid, rewardAmount: rewardAmount);

      if (success) {
        await loadUserToken(uid);
        await loadUserTokenLogs(uid);
        return true;
      } else {
        _setError('일일 보상을 받을 수 없습니다.');
        return false;
      }
    } catch (e) {
      _setError('일일 보상 지급에 실패했습니다: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// 토큰 사용
  Future<bool> spendTokens(int amount, {String? description}) async {
    final TokenStateModel state = await ref.read(tokenViewModelProvider.future);
    if (state.userToken == null) {
      return false;
    }
    final user = ref.read(firebaseAuthProvider).currentUser;
    final uid = user?.uid;
    if (uid == null || uid == '') {
      return false;
    }

    if (state.userToken!.currentTokens < amount) {
      _setError(
          '토큰이 부족합니다. 현재 보유: ${state.userToken!.currentTokens}, 필요: $amount');
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      final success = await _tokenService.spendTokens(uid, amount,
          description: description);

      if (success) {
        await loadUserToken(uid);
        await loadUserTokenLogs(uid);
        return true;
      } else {
        _setError('토큰 사용에 실패했습니다.');
        return false;
      }
    } catch (e) {
      _setError('토큰 사용 중 오류가 발생했습니다: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// 토큰 구매 처리
  Future<bool> purchaseTokens(int amount, double price,
      {String? transactionId}) async {
    _setLoading(true);
    _clearError();

    final user = ref.read(firebaseAuthProvider).currentUser;
    final uid = user?.uid;
    if (uid == null || uid == '') {
      return false;
    }

    try {
      await _tokenService.purchaseTokens(uid, amount, price,
          transactionId: transactionId);

      await loadUserToken(uid);
      await loadUserTokenLogs(uid);
      return true;
    } catch (e) {
      _setError('토큰 구매에 실패했습니다: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// 토큰 추가 (관리자용)
  Future<bool> addTokens(String userId, int amount,
      {String? description}) async {
    _setLoading(true);
    _clearError();

    try {
      await _tokenService.addTokens(userId, amount, description: description);

      await loadUserToken(userId);
      await loadUserTokenLogs(userId);
      return true;
    } catch (e) {
      _setError('토큰 추가에 실패했습니다: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// 토큰 잔액 확인
  Future<int> checkTokenBalance(String userId) async {
    try {
      return await _tokenService.getUserTokenBalance(userId);
    } catch (e) {
      _setError('토큰 잔액 확인에 실패했습니다: $e');
      return 0;
    }
  }

  /// 특정 타입의 로그만 필터링
  Future<List<TokenLogModel>> getLogsByType(TokenLogType type) async {
    final state = await ref.read(tokenViewModelProvider.future);

    return state.tokenLogs.where((log) => log.type == type).toList();
  }

  /// 최근 N일간의 로그만 필터링
  Future<List<TokenLogModel>> getLogsByDays(int days) async {
    final state = await ref.read(tokenViewModelProvider.future);
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    return state.tokenLogs
        .where((log) => log.createdAt.isAfter(cutoffDate))
        .toList();
  }

  /// 토큰 사용 통계 계산
  Future<Map<String, int>> getTokenStatistics() async {
    final state = await ref.read(tokenViewModelProvider.future);
    final tokenLogs = state.tokenLogs;
    final now = DateTime.now();
    final thisMonth = DateTime(now.year, now.month);
    final lastMonth = DateTime(now.year, now.month - 1);

    int thisMonthEarned = 0;
    int thisMonthSpent = 0;
    int lastMonthEarned = 0;
    int lastMonthSpent = 0;

    for (final log in tokenLogs) {
      if (log.amount > 0) {
        if (log.createdAt.isAfter(thisMonth)) {
          thisMonthEarned += log.amount;
        } else if (log.createdAt.isAfter(lastMonth)) {
          lastMonthEarned += log.amount;
        }
      } else {
        if (log.createdAt.isAfter(thisMonth)) {
          thisMonthSpent += log.amount.abs();
        } else if (log.createdAt.isAfter(lastMonth)) {
          lastMonthSpent += log.amount.abs();
        }
      }
    }

    return {
      'thisMonthEarned': thisMonthEarned,
      'thisMonthSpent': thisMonthSpent,
      'lastMonthEarned': lastMonthEarned,
      'lastMonthSpent': lastMonthSpent,
    };
  }

  /// 에러 초기화
  void _clearError() {
    update((state) {
      if (state.error != null) {
        return state.copyWith(error: null);
      }
      return state;
    });
  }

  /// 에러 설정
  void _setError(String error) {
    update(
      (state) => state.copyWith(error: error),
    );
  }

  /// 로딩 상태 설정
  void _setLoading(bool loading) {
    update((state) => state.copyWith(isLoading: loading));
  }
}
