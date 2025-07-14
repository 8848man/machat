import 'package:flutter/foundation.dart';
import 'package:machat/features/token/repositories/token_package_repository.dart';
import '../models/token_package_model.dart';
import '../interfaces/token_service.dart';

/// 토큰 패키지 뷰모델 - 토큰 패키지 관련 비즈니스 로직을 관리
class TokenPackageViewModel extends ChangeNotifier {
  final TokenPackageService _packageService;

  List<TokenPackageModel> _activePackages = [];
  List<TokenPackageModel> _popularPackages = [];
  TokenPackageModel? _selectedPackage;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<TokenPackageModel> get activePackages => _activePackages;
  List<TokenPackageModel> get popularPackages => _popularPackages;
  TokenPackageModel? get selectedPackage => _selectedPackage;
  bool get isLoading => _isLoading;
  String? get error => _error;

  TokenPackageViewModel({TokenPackageService? packageService})
      : _packageService = packageService ?? FirebaseTokenPackageService();

  /// 모든 활성화된 토큰 패키지를 로드
  Future<void> loadActivePackages() async {
    _setLoading(true);
    _clearError();

    try {
      _activePackages = await _packageService.getActivePackages();
      notifyListeners();
    } catch (e) {
      _setError('토큰 패키지를 불러오는데 실패했습니다: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// 인기 토큰 패키지를 로드
  Future<void> loadPopularPackages() async {
    _setLoading(true);
    _clearError();

    try {
      _popularPackages = await _packageService.getPopularPackages();
      notifyListeners();
    } catch (e) {
      _setError('인기 토큰 패키지를 불러오는데 실패했습니다: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// 특정 토큰 패키지를 로드
  Future<void> loadPackageById(String packageId) async {
    _setLoading(true);
    _clearError();

    try {
      _selectedPackage = await _packageService.getPackageById(packageId);
      notifyListeners();
    } catch (e) {
      _setError('토큰 패키지 정보를 불러오는데 실패했습니다: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// 패키지 선택
  void selectPackage(TokenPackageModel package) {
    _selectedPackage = package;
    notifyListeners();
  }

  /// 선택된 패키지 해제
  void clearSelectedPackage() {
    _selectedPackage = null;
    notifyListeners();
  }

  /// 패키지 필터링 (가격순)
  List<TokenPackageModel> getPackagesSortedByPrice({bool ascending = true}) {
    final sorted = List<TokenPackageModel>.from(_activePackages);
    if (ascending) {
      sorted.sort((a, b) => a.price.compareTo(b.price));
    } else {
      sorted.sort((a, b) => b.price.compareTo(a.price));
    }
    return sorted;
  }

  /// 패키지 필터링 (토큰 수량순)
  List<TokenPackageModel> getPackagesSortedByTokenAmount(
      {bool ascending = true}) {
    final sorted = List<TokenPackageModel>.from(_activePackages);
    if (ascending) {
      sorted.sort((a, b) => a.totalTokens.compareTo(b.totalTokens));
    } else {
      sorted.sort((a, b) => b.totalTokens.compareTo(a.totalTokens));
    }
    return sorted;
  }

  /// 패키지 필터링 (가성비순)
  List<TokenPackageModel> getPackagesSortedByValue() {
    final sorted = List<TokenPackageModel>.from(_activePackages);
    sorted.sort((a, b) => a.pricePerToken.compareTo(b.pricePerToken));
    return sorted;
  }

  /// 특정 가격 범위의 패키지 필터링
  List<TokenPackageModel> getPackagesInPriceRange(
      double minPrice, double maxPrice) {
    return _activePackages.where((package) {
      return package.price >= minPrice && package.price <= maxPrice;
    }).toList();
  }

  /// 특정 토큰 수량 범위의 패키지 필터링
  List<TokenPackageModel> getPackagesInTokenRange(
      int minTokens, int maxTokens) {
    return _activePackages.where((package) {
      return package.totalTokens >= minTokens &&
          package.totalTokens <= maxTokens;
    }).toList();
  }

  /// 보너스가 있는 패키지만 필터링
  List<TokenPackageModel> getPackagesWithBonus() {
    return _activePackages.where((package) {
      return package.bonusTokens != null && package.bonusTokens! > 0;
    }).toList();
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
}
