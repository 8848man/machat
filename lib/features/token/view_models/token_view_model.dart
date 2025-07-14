import 'package:flutter/foundation.dart';
import 'package:machat/features/token/repositories/token_repository.dart';
import '../models/token_model.dart';
import '../models/token_log_model.dart';
import '../interfaces/token_service.dart';

/// 토큰 뷰모델 - 토큰 관련 비즈니스 로직을 관리
class TokenViewModel extends ChangeNotifier {
  final TokenService _tokenService;

  TokenModel? _userToken;
  List<TokenLogModel> _tokenLogs = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  TokenModel? get userToken => _userToken;
  List<TokenLogModel> get tokenLogs => _tokenLogs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // 편의 getters
  int get currentTokens => _userToken?.currentTokens ?? 0;
  int get totalEarnedTokens => _userToken?.totalEarnedTokens ?? 0;
  int get totalSpentTokens => _userToken?.totalSpentTokens ?? 0;
  bool get canReceiveDailyReward => _userToken?.canReceiveDailyReward() ?? true;

  TokenViewModel({TokenService? tokenService})
      : _tokenService = tokenService ?? FirebaseTokenService();

  /// 사용자의 토큰 정보를 로드
  Future<void> loadUserToken(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      _userToken = await _tokenService.getUserToken(userId);
      notifyListeners();
    } catch (e) {
      _setError('토큰 정보를 불러오는데 실패했습니다: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// 사용자의 토큰 로그를 로드
  Future<void> loadUserTokenLogs(String userId, {int limit = 50}) async {
    _setLoading(true);
    _clearError();

    try {
      _tokenLogs = await _tokenService.getUserTokenLogs(userId, limit: limit);
      notifyListeners();
    } catch (e) {
      _setError('토큰 로그를 불러오는데 실패했습니다: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// 일일 보상 토큰 지급
  Future<bool> claimDailyReward(String userId, {int rewardAmount = 10}) async {
    if (!canReceiveDailyReward) {
      _setError('오늘은 이미 보상을 받았습니다.');
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      final success = await _tokenService.giveDailyReward(userId,
          rewardAmount: rewardAmount);

      if (success) {
        await loadUserToken(userId);
        await loadUserTokenLogs(userId);
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
  Future<bool> spendTokens(String userId, int amount,
      {String? description}) async {
    if (currentTokens < amount) {
      _setError('토큰이 부족합니다. 현재 보유: $currentTokens, 필요: $amount');
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      final success = await _tokenService.spendTokens(userId, amount,
          description: description);

      if (success) {
        await loadUserToken(userId);
        await loadUserTokenLogs(userId);
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
  Future<bool> purchaseTokens(String userId, int amount, double price,
      {String? transactionId}) async {
    _setLoading(true);
    _clearError();

    try {
      await _tokenService.purchaseTokens(userId, amount, price,
          transactionId: transactionId);

      await loadUserToken(userId);
      await loadUserTokenLogs(userId);
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
  List<TokenLogModel> getLogsByType(TokenLogType type) {
    return _tokenLogs.where((log) => log.type == type).toList();
  }

  /// 최근 N일간의 로그만 필터링
  List<TokenLogModel> getLogsByDays(int days) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    return _tokenLogs
        .where((log) => log.createdAt.isAfter(cutoffDate))
        .toList();
  }

  /// 토큰 사용 통계 계산
  Map<String, int> getTokenStatistics() {
    final now = DateTime.now();
    final thisMonth = DateTime(now.year, now.month);
    final lastMonth = DateTime(now.year, now.month - 1);

    int thisMonthEarned = 0;
    int thisMonthSpent = 0;
    int lastMonthEarned = 0;
    int lastMonthSpent = 0;

    for (final log in _tokenLogs) {
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
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }

  /// 에러 설정
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  /// 로딩 상태 설정
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// 뷰모델 초기화
  void dispose() {
    super.dispose();
  }
}
