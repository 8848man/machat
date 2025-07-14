import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:machat/features/token/view_models/token_package_view_model.dart';
import 'package:machat/features/token/interfaces/token_service.dart';
import 'package:machat/features/token/models/token_package_model.dart';

import 'token_package_view_model_test.mocks.dart';

@GenerateMocks([TokenPackageService])
void main() {
  group('TokenPackageViewModel', () {
    late TokenPackageViewModel packageViewModel;
    late MockTokenPackageService mockPackageService;

    setUp(() {
      mockPackageService = MockTokenPackageService();
      packageViewModel = TokenPackageViewModel(packageService: mockPackageService);
    });

    group('loadActivePackages', () {
      test('should load active packages successfully', () async {
        final mockPackages = [
          TokenPackageModel(
            id: 'package_1',
            name: '기본 패키지',
            description: '1000 토큰',
            tokenAmount: 1000,
            price: 10000,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
          TokenPackageModel(
            id: 'package_2',
            name: '인기 패키지',
            description: '5000 토큰 + 500 보너스',
            tokenAmount: 5000,
            price: 45000,
            isPopular: true,
            bonusTokens: 500,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
        ];

        when(mockPackageService.getActivePackages()).thenAnswer((_) async => mockPackages);

        await packageViewModel.loadActivePackages();

        expect(packageViewModel.activePackages, mockPackages);
        expect(packageViewModel.isLoading, false);
        expect(packageViewModel.error, isNull);
      });

      test('should handle error when loading active packages', () async {
        when(mockPackageService.getActivePackages()).thenThrow(Exception('Network error'));

        await packageViewModel.loadActivePackages();

        expect(packageViewModel.activePackages, isEmpty);
        expect(packageViewModel.isLoading, false);
        expect(packageViewModel.error, contains('토큰 패키지를 불러오는데 실패했습니다'));
      });
    });

    group('loadPopularPackages', () {
      test('should load popular packages successfully', () async {
        final mockPackages = [
          TokenPackageModel(
            id: 'package_1',
            name: '인기 패키지 1',
            description: '1000 토큰',
            tokenAmount: 1000,
            price: 10000,
            isPopular: true,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
          TokenPackageModel(
            id: 'package_2',
            name: '인기 패키지 2',
            description: '2000 토큰',
            tokenAmount: 2000,
            price: 20000,
            isPopular: true,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
        ];

        when(mockPackageService.getPopularPackages()).thenAnswer((_) async => mockPackages);

        await packageViewModel.loadPopularPackages();

        expect(packageViewModel.popularPackages, mockPackages);
        expect(packageViewModel.isLoading, false);
        expect(packageViewModel.error, isNull);
      });

      test('should handle error when loading popular packages', () async {
        when(mockPackageService.getPopularPackages()).thenThrow(Exception('Network error'));

        await packageViewModel.loadPopularPackages();

        expect(packageViewModel.popularPackages, isEmpty);
        expect(packageViewModel.isLoading, false);
        expect(packageViewModel.error, contains('인기 토큰 패키지를 불러오는데 실패했습니다'));
      });
    });

    group('loadPackageById', () {
      test('should load package by id successfully', () async {
        final mockPackage = TokenPackageModel(
          id: 'package_123',
          name: '기본 패키지',
          description: '1000 토큰',
          tokenAmount: 1000,
          price: 10000,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );

        when(mockPackageService.getPackageById('package_123')).thenAnswer((_) async => mockPackage);

        await packageViewModel.loadPackageById('package_123');

        expect(packageViewModel.selectedPackage, mockPackage);
        expect(packageViewModel.isLoading, false);
        expect(packageViewModel.error, isNull);
      });

      test('should handle error when loading package by id', () async {
        when(mockPackageService.getPackageById('package_123')).thenThrow(Exception('Network error'));

        await packageViewModel.loadPackageById('package_123');

        expect(packageViewModel.selectedPackage, isNull);
        expect(packageViewModel.isLoading, false);
        expect(packageViewModel.error, contains('토큰 패키지 정보를 불러오는데 실패했습니다'));
      });
    });

    group('selectPackage', () {
      test('should select package', () {
        final package = TokenPackageModel(
          id: 'package_123',
          name: '기본 패키지',
          description: '1000 토큰',
          tokenAmount: 1000,
          price: 10000,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );

        packageViewModel.selectPackage(package);

        expect(packageViewModel.selectedPackage, package);
      });
    });

    group('clearSelectedPackage', () {
      test('should clear selected package', () {
        final package = TokenPackageModel(
          id: 'package_123',
          name: '기본 패키지',
          description: '1000 토큰',
          tokenAmount: 1000,
          price: 10000,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );

        packageViewModel.selectPackage(package);
        expect(packageViewModel.selectedPackage, package);

        packageViewModel.clearSelectedPackage();
        expect(packageViewModel.selectedPackage, isNull);
      });
    });

    group('getPackagesSortedByPrice', () {
      test('should sort packages by price ascending', () {
        final packages = [
          TokenPackageModel(
            id: 'package_1',
            name: '고가 패키지',
            description: '2000 토큰',
            tokenAmount: 2000,
            price: 20000,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
          TokenPackageModel(
            id: 'package_2',
            name: '저가 패키지',
            description: '1000 토큰',
            tokenAmount: 1000,
            price: 10000,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
        ];

        // Manually set active packages
        packageViewModel = TokenPackageViewModel(packageService: mockPackageService);

        final sorted = packageViewModel.getPackagesSortedByPrice(ascending: true);

        expect(sorted[0].price, 10000);
        expect(sorted[1].price, 20000);
      });

      test('should sort packages by price descending', () {
        final packages = [
          TokenPackageModel(
            id: 'package_1',
            name: '저가 패키지',
            description: '1000 토큰',
            tokenAmount: 1000,
            price: 10000,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
          TokenPackageModel(
            id: 'package_2',
            name: '고가 패키지',
            description: '2000 토큰',
            tokenAmount: 2000,
            price: 20000,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
        ];

        packageViewModel = TokenPackageViewModel(packageService: mockPackageService);

        final sorted = packageViewModel.getPackagesSortedByPrice(ascending: false);

        expect(sorted[0].price, 20000);
        expect(sorted[1].price, 10000);
      });
    });

    group('getPackagesSortedByTokenAmount', () {
      test('should sort packages by token amount ascending', () {
        final packages = [
          TokenPackageModel(
            id: 'package_1',
            name: '대량 패키지',
            description: '2000 토큰',
            tokenAmount: 2000,
            price: 20000,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
          TokenPackageModel(
            id: 'package_2',
            name: '소량 패키지',
            description: '1000 토큰',
            tokenAmount: 1000,
            price: 10000,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
        ];

        packageViewModel = TokenPackageViewModel(packageService: mockPackageService);

        final sorted = packageViewModel.getPackagesSortedByTokenAmount(ascending: true);

        expect(sorted[0].tokenAmount, 1000);
        expect(sorted[1].tokenAmount, 2000);
      });
    });

    group('getPackagesSortedByValue', () {
      test('should sort packages by value (price per token)', () {
        final packages = [
          TokenPackageModel(
            id: 'package_1',
            name: '저가성비 패키지',
            description: '1000 토큰',
            tokenAmount: 1000,
            price: 10000,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
          TokenPackageModel(
            id: 'package_2',
            name: '고가성비 패키지',
            description: '1000 토큰',
            tokenAmount: 1000,
            price: 15000,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
        ];

        packageViewModel = TokenPackageViewModel(packageService: mockPackageService);

        final sorted = packageViewModel.getPackagesSortedByValue();

        expect(sorted[0].pricePerToken, 10.0); // 10000 / 1000
        expect(sorted[1].pricePerToken, 15.0); // 15000 / 1000
      });
    });

    group('getPackagesInPriceRange', () {
      test('should filter packages by price range', () {
        final packages = [
          TokenPackageModel(
            id: 'package_1',
            name: '저가 패키지',
            description: '500 토큰',
            tokenAmount: 500,
            price: 5000,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
          TokenPackageModel(
            id: 'package_2',
            name: '중간 패키지',
            description: '1000 토큰',
            tokenAmount: 1000,
            price: 10000,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
          TokenPackageModel(
            id: 'package_3',
            name: '고가 패키지',
            description: '2000 토큰',
            tokenAmount: 2000,
            price: 20000,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
        ];

        packageViewModel = TokenPackageViewModel(packageService: mockPackageService);

        final filtered = packageViewModel.getPackagesInPriceRange(5000, 15000);

        expect(filtered, hasLength(2));
        expect(filtered.every((p) => p.price >= 5000 && p.price <= 15000), true);
      });
    });

    group('getPackagesInTokenRange', () {
      test('should filter packages by token amount range', () {
        final packages = [
          TokenPackageModel(
            id: 'package_1',
            name: '소량 패키지',
            description: '500 토큰',
            tokenAmount: 500,
            price: 5000,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
          TokenPackageModel(
            id: 'package_2',
            name: '중간 패키지',
            description: '1000 토큰',
            tokenAmount: 1000,
            price: 10000,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
          TokenPackageModel(
            id: 'package_3',
            name: '대량 패키지',
            description: '2000 토큰',
            tokenAmount: 2000,
            price: 20000,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
        ];

        packageViewModel = TokenPackageViewModel(packageService: mockPackageService);

        final filtered = packageViewModel.getPackagesInTokenRange(500, 1500);

        expect(filtered, hasLength(2));
        expect(filtered.every((p) => p.totalTokens >= 500 && p.totalTokens <= 1500), true);
      });
    });

    group('getPackagesWithBonus', () {
      test('should filter packages with bonus tokens', () {
        final packages = [
          TokenPackageModel(
            id: 'package_1',
            name: '일반 패키지',
            description: '1000 토큰',
            tokenAmount: 1000,
            price: 10000,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
          TokenPackageModel(
            id: 'package_2',
            name: '보너스 패키지',
            description: '1000 토큰 + 100 보너스',
            tokenAmount: 1000,
            price: 10000,
            bonusTokens: 100,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
          TokenPackageModel(
            id: 'package_3',
            name: '대보너스 패키지',
            description: '2000 토큰 + 500 보너스',
            tokenAmount: 2000,
            price: 20000,
            bonusTokens: 500,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
        ];

        packageViewModel = TokenPackageViewModel(packageService: mockPackageService);

        final bonusPackages = packageViewModel.getPackagesWithBonus();

        expect(bonusPackages, hasLength(2));
        expect(bonusPackages.every((p) => p.bonusTokens != null && p.bonusTokens! > 0), true);
      });
    });
  });
} 