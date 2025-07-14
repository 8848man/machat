import 'package:flutter_test/flutter_test.dart';
import 'package:machat/features/token/repositories/token_repository.dart';
import 'package:machat/features/token/repositories/token_package_repository.dart';
import 'package:machat/features/token/view_models/token_view_model.dart';
import 'package:machat/features/token/view_models/token_package_view_model.dart';
import 'package:machat/features/token/models/token_model.dart';
import 'package:machat/features/token/models/token_package_model.dart';
import 'package:machat/features/token/models/token_log_model.dart';

void main() {
  group('Token Integration Tests', () {
    late FirebaseTokenService tokenService;
    late FirebaseTokenPackageService packageService;
    late TokenViewModel tokenViewModel;
    late TokenPackageViewModel packageViewModel;

    setUp(() {
      // 실제 Firebase 인스턴스를 사용하지 않고 테스트용 설정
      // 실제 환경에서는 Firebase Test SDK를 사용해야 함
      tokenService = FirebaseTokenService();
      packageService = FirebaseTokenPackageService();
      tokenViewModel = TokenViewModel(tokenService: tokenService);
      packageViewModel = TokenPackageViewModel(packageService: packageService);
    });

    group('Token Management Flow', () {
      test('should handle complete token lifecycle', () async {
        const userId = 'test_user_123';
        const packageId = 'test_package_123';

        // 1. 사용자 토큰 정보 로드 (신규 사용자)
        await tokenViewModel.loadUserToken(userId);

        // 신규 사용자는 토큰이 0이어야 함
        expect(tokenViewModel.currentTokens, 0);
        expect(tokenViewModel.totalEarnedTokens, 0);
        expect(tokenViewModel.totalSpentTokens, 0);

        // 2. 일일 보상 받기
        final dailyRewardResult = await tokenViewModel.claimDailyReward(userId);
        expect(dailyRewardResult, true);

        // 3. 토큰 잔액 확인
        final balance = await tokenViewModel.checkTokenBalance(userId);
        expect(balance, greaterThan(0));

        // 4. 토큰 사용
        final spendResult =
            await tokenViewModel.spendTokens(userId, 5, description: '테스트 사용');
        expect(spendResult, true);

        // 5. 토큰 로그 확인
        await tokenViewModel.loadUserTokenLogs(userId);
        expect(tokenViewModel.tokenLogs, isNotEmpty);

        // 6. 일일 보상 중복 시도 (실패해야 함)
        final duplicateRewardResult =
            await tokenViewModel.claimDailyReward(userId);
        expect(duplicateRewardResult, false);
      });

      test('should handle token purchase flow', () async {
        const userId = 'test_user_456';
        const packageId = 'test_package_456';

        // 1. 패키지 정보 로드
        await packageViewModel.loadActivePackages();
        expect(packageViewModel.activePackages, isNotEmpty);

        // 2. 특정 패키지 선택
        final selectedPackage = packageViewModel.activePackages.first;
        packageViewModel.selectPackage(selectedPackage);
        expect(packageViewModel.selectedPackage, selectedPackage);

        // 3. 토큰 구매 시뮬레이션
        final purchaseResult = await tokenViewModel.purchaseTokens(
          userId,
          selectedPackage.totalTokens,
          selectedPackage.price,
          transactionId: 'test_transaction_123',
        );
        expect(purchaseResult, true);

        // 4. 구매 후 토큰 잔액 확인
        final balance = await tokenViewModel.checkTokenBalance(userId);
        expect(balance, selectedPackage.totalTokens);
      });

      test('should handle insufficient tokens scenario', () async {
        const userId = 'test_user_789';

        // 1. 사용자 토큰 정보 로드
        await tokenViewModel.loadUserToken(userId);

        // 2. 현재 토큰보다 많은 토큰 사용 시도
        final spendResult = await tokenViewModel.spendTokens(
          userId,
          tokenViewModel.currentTokens + 100,
          description: '부족한 토큰 사용',
        );
        expect(spendResult, false);
        expect(tokenViewModel.error, contains('토큰이 부족합니다'));
      });

      test('should handle package filtering and sorting', () async {
        // 1. 활성 패키지 로드
        await packageViewModel.loadActivePackages();
        expect(packageViewModel.activePackages, isNotEmpty);

        // 2. 가격별 정렬 테스트
        final sortedByPrice =
            packageViewModel.getPackagesSortedByPrice(ascending: true);
        expect(sortedByPrice, isNotEmpty);

        // 가격이 오름차순으로 정렬되었는지 확인
        for (int i = 1; i < sortedByPrice.length; i++) {
          expect(sortedByPrice[i].price,
              greaterThanOrEqualTo(sortedByPrice[i - 1].price));
        }

        // 3. 토큰 수량별 정렬 테스트
        final sortedByTokens =
            packageViewModel.getPackagesSortedByTokenAmount(ascending: true);
        expect(sortedByTokens, isNotEmpty);

        // 4. 가성비별 정렬 테스트
        final sortedByValue = packageViewModel.getPackagesSortedByValue();
        expect(sortedByValue, isNotEmpty);

        // 5. 가격 범위 필터링 테스트
        final maxPrice = packageViewModel.activePackages
            .map((p) => p.price)
            .reduce((a, b) => a > b ? a : b);
        final filteredByPrice =
            packageViewModel.getPackagesInPriceRange(0, maxPrice ~/ 2);
        expect(filteredByPrice.every((p) => p.price <= maxPrice ~/ 2), true);

        // 6. 보너스 토큰이 있는 패키지 필터링
        final packagesWithBonus = packageViewModel.getPackagesWithBonus();
        expect(
            packagesWithBonus
                .every((p) => p.bonusTokens != null && p.bonusTokens! > 0),
            true);
      });

      test('should handle token log filtering', () async {
        const userId = 'test_user_logs';

        // 1. 토큰 로그 로드
        await tokenViewModel.loadUserTokenLogs(userId);

        // 2. 타입별 필터링 테스트
        final dailyRewards =
            tokenViewModel.getLogsByType(TokenLogType.dailyReward);
        final usages = tokenViewModel.getLogsByType(TokenLogType.usage);
        final purchases = tokenViewModel.getLogsByType(TokenLogType.purchase);

        // 각 타입별로 올바른 타입만 포함되어 있는지 확인
        expect(
            dailyRewards.every((log) => log.type == TokenLogType.dailyReward),
            true);
        expect(usages.every((log) => log.type == TokenLogType.usage), true);
        expect(
            purchases.every((log) => log.type == TokenLogType.purchase), true);

        // 3. 날짜별 필터링 테스트
        final recentLogs = tokenViewModel.getLogsByDays(7);
        final oldDate = DateTime.now().subtract(const Duration(days: 8));

        // 최근 7일 로그는 8일 전보다 최신이어야 함
        expect(recentLogs.every((log) => log.createdAt.isAfter(oldDate)), true);
      });

      test('should handle error scenarios gracefully', () async {
        const invalidUserId = 'invalid_user_123';

        // 1. 존재하지 않는 사용자의 토큰 정보 로드
        await tokenViewModel.loadUserToken(invalidUserId);
        expect(tokenViewModel.userToken, isNull);

        // 2. 존재하지 않는 사용자의 토큰 로그 로드
        await tokenViewModel.loadUserTokenLogs(invalidUserId);
        expect(tokenViewModel.tokenLogs, isEmpty);

        // 3. 존재하지 않는 패키지 로드
        await packageViewModel.loadPackageById('nonexistent_package');
        expect(packageViewModel.selectedPackage, isNull);
      });

      test('should maintain data consistency across operations', () async {
        const userId = 'test_user_consistency';

        // 1. 초기 상태 확인
        await tokenViewModel.loadUserToken(userId);
        final initialBalance = tokenViewModel.currentTokens;
        final initialEarned = tokenViewModel.totalEarnedTokens;
        final initialSpent = tokenViewModel.totalSpentTokens;

        // 2. 토큰 획득
        await tokenViewModel.addTokens(userId, 100, description: '테스트 획득');
        await tokenViewModel.loadUserToken(userId);

        // 3. 토큰 사용
        await tokenViewModel.spendTokens(userId, 50, description: '테스트 사용');
        await tokenViewModel.loadUserToken(userId);

        // 4. 일관성 검증
        expect(tokenViewModel.currentTokens, initialBalance + 100 - 50);
        expect(tokenViewModel.totalEarnedTokens, initialEarned + 100);
        expect(tokenViewModel.totalSpentTokens, initialSpent + 50);

        // 5. 로그 확인
        await tokenViewModel.loadUserTokenLogs(userId);
        expect(tokenViewModel.tokenLogs.length, greaterThanOrEqualTo(2));
      });
    });

    group('Performance Tests', () {
      test('should handle large number of operations efficiently', () async {
        const userId = 'test_user_performance';
        const iterations = 10;

        // 1. 여러 번의 토큰 추가/사용 작업
        for (int i = 0; i < iterations; i++) {
          await tokenViewModel.addTokens(userId, 10,
              description: '성능 테스트 추가 $i');
          await tokenViewModel.spendTokens(userId, 5,
              description: '성능 테스트 사용 $i');
        }

        // 2. 최종 상태 확인
        await tokenViewModel.loadUserToken(userId);
        expect(tokenViewModel.currentTokens, iterations * 5); // 10 - 5 = 5씩 증가
        expect(tokenViewModel.totalEarnedTokens, iterations * 10);
        expect(tokenViewModel.totalSpentTokens, iterations * 5);

        // 3. 로그 로드 성능 확인
        await tokenViewModel.loadUserTokenLogs(userId);
        expect(tokenViewModel.tokenLogs.length, iterations * 2);
      });

      test('should handle package loading efficiently', () async {
        // 1. 활성 패키지 로드
        final stopwatch = Stopwatch()..start();
        await packageViewModel.loadActivePackages();
        stopwatch.stop();

        // 로드 시간이 합리적인 범위 내에 있는지 확인 (1초 이내)
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
        expect(packageViewModel.activePackages, isNotEmpty);

        // 2. 인기 패키지 로드
        stopwatch.reset();
        stopwatch.start();
        await packageViewModel.loadPopularPackages();
        stopwatch.stop();

        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      });
    });
  });
}
