import 'package:machat/features/token/features/package/models/token_package_model.dart';

/// 토큰 패키지 서비스 인터페이스
abstract class ITokenPackageService {
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
