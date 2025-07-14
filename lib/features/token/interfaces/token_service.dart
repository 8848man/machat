import '../models/token_model.dart';
import '../models/token_log_model.dart';
import '../models/token_package_model.dart';

/// 토큰 서비스 인터페이스
/// 이 인터페이스를 구현하여 다양한 토큰 관리 시스템을 지원할 수 있습니다.
abstract class TokenService {
  /// 사용자의 토큰 정보를 가져옴
  Future<TokenModel?> getUserToken(String userId);

  /// 사용자의 토큰 잔액을 가져옴
  Future<int> getUserTokenBalance(String userId);

  /// 토큰을 추가
  Future<void> addTokens(String userId, int amount, {String? description});

  /// 토큰을 사용
  Future<bool> spendTokens(String userId, int amount, {String? description});

  /// 일일 보상 토큰 지급
  Future<bool> giveDailyReward(String userId, {int rewardAmount = 10});

  /// 토큰 구매 처리
  Future<void> purchaseTokens(String userId, int amount, double price, {String? transactionId});

  /// 사용자의 토큰 로그를 가져옴
  Future<List<TokenLogModel>> getUserTokenLogs(String userId, {int limit = 50});

  /// 특정 타입의 로그만 가져옴
  Future<List<TokenLogModel>> getLogsByType(String userId, TokenLogType type);

  /// 최근 N일간의 로그만 가져옴
  Future<List<TokenLogModel>> getLogsByDays(String userId, int days);
}

/// 토큰 패키지 서비스 인터페이스
abstract class TokenPackageService {
  /// 모든 활성화된 토큰 패키지를 가져옴
  Future<List<TokenPackageModel>> getActivePackages();

  /// 인기 토큰 패키지를 가져옴
  Future<List<TokenPackageModel>> getPopularPackages();

  /// 특정 토큰 패키지를 가져옴
  Future<TokenPackageModel?> getPackageById(String packageId);

  /// 가격대별 토큰 패키지를 가져옴
  Future<List<TokenPackageModel>> getPackagesByPriceRange({
    double? minPrice,
    double? maxPrice,
  });

  /// 토큰 수량별 패키지를 가져옴
  Future<List<TokenPackageModel>> getPackagesByTokenAmount({
    int? minTokens,
    int? maxTokens,
  });

  /// 가장 좋은 가성비 패키지를 가져옴
  Future<TokenPackageModel?> getBestValuePackage();

  /// 특정 가격 이하의 패키지를 가져옴
  Future<List<TokenPackageModel>> getPackagesUnderPrice(double maxPrice);
}

/// 토큰 통계 서비스 인터페이스
abstract class TokenStatisticsService {
  /// 사용자의 토큰 통계를 계산
  Future<Map<String, int>> getUserTokenStatistics(String userId);

  /// 월별 토큰 사용 통계
  Future<Map<String, int>> getMonthlyTokenStatistics(String userId, int year, int month);

  /// 토큰 사용 패턴 분석
  Future<Map<String, dynamic>> analyzeTokenUsagePattern(String userId);
}

/// 토큰 보상 서비스 인터페이스
abstract class TokenRewardService {
  /// 일일 보상 지급
  Future<bool> giveDailyReward(String userId, {int rewardAmount = 10});

  /// 출석 체크 보상
  Future<bool> giveAttendanceReward(String userId, {int rewardAmount = 5});

  /// 미션 완료 보상
  Future<bool> giveMissionReward(String userId, String missionId, {int rewardAmount = 20});

  /// 레벨업 보상
  Future<bool> giveLevelUpReward(String userId, int level, {int rewardAmount = 50});

  /// 특별 이벤트 보상
  Future<bool> giveEventReward(String userId, String eventId, {int rewardAmount = 100});
}

/// 토큰 결제 서비스 인터페이스
abstract class TokenPaymentService {
  /// 토큰 패키지 구매
  Future<bool> purchaseTokenPackage(String userId, String packageId, String paymentMethod);

  /// 결제 검증
  Future<bool> verifyPayment(String transactionId);

  /// 환불 처리
  Future<bool> refundTokens(String userId, String transactionId, {String? reason});

  /// 결제 내역 조회
  Future<List<Map<String, dynamic>>> getPaymentHistory(String userId);
} 