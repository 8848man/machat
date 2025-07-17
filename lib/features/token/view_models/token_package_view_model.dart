import 'package:machat/features/token/models/token_package_state_model.dart';
import 'package:machat/features/token/providers/selected_package_provider.dart';
import 'package:machat/features/token/repositories/token_package_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/token_package_model.dart';
import '../interfaces/token_service.dart';

part 'token_package_view_model.g.dart';

@riverpod
class TokenPackageViewModel extends _$TokenPackageViewModel {
  late final TokenPackageService _packageService;
  @override
  Future<TokenPackageStateModel> build() async {
    _packageService = FirebaseTokenPackageService();

    return await getData();
  }

  Future<TokenPackageStateModel> getData() async {
    final List<TokenPackageModel> activePackage = await loadActivePackages();
    final List<TokenPackageModel> popularPackage = await loadPopularPackages();

    return TokenPackageStateModel(
        activePackages: activePackage, popularPackages: popularPackage);
  }

  /// 모든 활성화된 토큰 패키지를 로드
  Future<List<TokenPackageModel>> loadActivePackages() async {
    _setLoading(true);
    _clearError();

    try {
      return await _packageService.getActivePackages();
    } catch (e) {
      _setError('토큰 패키지를 불러오는데 실패했습니다: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// 인기 토큰 패키지를 로드
  Future<List<TokenPackageModel>> loadPopularPackages() async {
    _setLoading(true);
    _clearError();

    try {
      return await _packageService.getPopularPackages();
    } catch (e) {
      _setError('인기 토큰 패키지를 불러오는데 실패했습니다: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// 특정 토큰 패키지를 로드
  // Future<void> loadPackageById(String packageId) async {
  //   _setLoading(true);
  //   _clearError();

  //   try {
  //     final TokenPackageModel? selectedPackage =
  //         await _packageService.getPackageById(packageId);
  //     update((state) => state.copyWith(selectedPackage: selectedPackage));
  //   } catch (e) {
  //     _setError('토큰 패키지 정보를 불러오는데 실패했습니다: $e');
  //   } finally {
  //     _setLoading(false);
  //   }
  // }

  /// 패키지 선택
  void selectPackage(TokenPackageModel package) {
    ref.read(selectedPackageProvider.notifier).update((state) => package);
    // update((state) => state.copyWith(selectedPackage: package));
  }

  /// 패키지 필터링 (가격순)
  void getPackagesSortedByPrice({bool ascending = true}) {
    update((state) {
      final sorted = List<TokenPackageModel>.from(state.activePackages);
      if (ascending) {
        sorted.sort((a, b) => a.price.compareTo(b.price));
      } else {
        sorted.sort((a, b) => b.price.compareTo(a.price));
      }
      return state.copyWith(activePackages: sorted);
    });
  }

  /// 패키지 필터링 (토큰 수량순)
  void getPackagesSortedByTokenAmount({bool ascending = true}) {
    update((state) {
      final sorted = List<TokenPackageModel>.from(state.activePackages);
      if (ascending) {
        sorted.sort((a, b) => a.totalTokens.compareTo(b.totalTokens));
      } else {
        sorted.sort((a, b) => b.totalTokens.compareTo(a.totalTokens));
      }
      return state.copyWith(activePackages: sorted);
    });
  }

  /// 패키지 필터링 (가성비순)
  void getPackagesSortedByValue() {
    update((state) {
      final sorted = List<TokenPackageModel>.from(state.activePackages);
      sorted.sort((a, b) => a.pricePerToken.compareTo(b.pricePerToken));
      return state.copyWith(activePackages: sorted);
    });
  }

  /// 특정 가격 범위의 패키지 필터링
  List<TokenPackageModel> getPackagesInPriceRange(
      double minPrice, double maxPrice) {
    return state.value!.activePackages.where((package) {
      return package.price >= minPrice && package.price <= maxPrice;
    }).toList();
  }

  /// 특정 토큰 수량 범위의 패키지 필터링
  List<TokenPackageModel> getPackagesInTokenRange(
      int minTokens, int maxTokens) {
    return state.value!.activePackages.where((package) {
      return package.totalTokens >= minTokens &&
          package.totalTokens <= maxTokens;
    }).toList();
  }

  /// 보너스가 있는 패키지만 필터링
  List<TokenPackageModel> getPackagesWithBonus() {
    return state.value!.activePackages.where((package) {
      return package.bonusTokens != null && package.bonusTokens! > 0;
    }).toList();
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
    update((state) => state.copyWith(error: error));
  }

  /// 로딩 상태 설정
  void _setLoading(bool loading) {
    update((state) => state.copyWith(isLoading: loading));
  }
}
