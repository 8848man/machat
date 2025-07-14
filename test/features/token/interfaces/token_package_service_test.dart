import 'package:flutter_test/flutter_test.dart';
import 'package:machat/features/token/interfaces/token_service.dart';
import 'package:machat/features/token/models/token_package_model.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('TokenPackageService Interface', () {
    late MockTokenPackageService mockPackageService;

    setUp(() {
      mockPackageService = MockTokenPackageService();
    });

    group('getActivePackages', () {
      test('should return list of active packages', () async {
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

        when(mockPackageService.getActivePackages())
            .thenAnswer((_) async => mockPackages);

        final result = await mockPackageService.getActivePackages();

        expect(result, hasLength(2));
        expect(result[0].name, '기본 패키지');
        expect(result[1].name, '인기 패키지');
        expect(result[1].isPopular, true);
      });

      test('should return empty list when no active packages', () async {
        when(mockPackageService.getActivePackages())
            .thenAnswer((_) async => []);

        final result = await mockPackageService.getActivePackages();

        expect(result, isEmpty);
      });
    });

    group('getPopularPackages', () {
      test('should return list of popular packages', () async {
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

        when(mockPackageService.getPopularPackages())
            .thenAnswer((_) async => mockPackages);

        final result = await mockPackageService.getPopularPackages();

        expect(result, hasLength(2));
        expect(result.every((p) => p.isPopular), true);
      });

      test('should return empty list when no popular packages', () async {
        when(mockPackageService.getPopularPackages())
            .thenAnswer((_) async => []);

        final result = await mockPackageService.getPopularPackages();

        expect(result, isEmpty);
      });
    });

    group('getPackageById', () {
      test('should return package when found', () async {
        final mockPackage = TokenPackageModel(
          id: 'package_123',
          name: '기본 패키지',
          description: '1000 토큰',
          tokenAmount: 1000,
          price: 10000,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );

        when(mockPackageService.getPackageById('package_123'))
            .thenAnswer((_) async => mockPackage);

        final result = await mockPackageService.getPackageById('package_123');

        expect(result, isNotNull);
        expect(result!.id, 'package_123');
        expect(result.name, '기본 패키지');
        expect(result.tokenAmount, 1000);
        expect(result.price, 10000);
      });

      test('should return null when package not found', () async {
        when(mockPackageService.getPackageById('nonexistent'))
            .thenAnswer((_) async => null);

        final result = await mockPackageService.getPackageById('nonexistent');

        expect(result, isNull);
      });
    });

    group('getPackagesByPriceRange', () {
      test('should return packages within price range', () async {
        final mockPackages = [
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
        ];

        when(mockPackageService.getPackagesByPriceRange(
                minPrice: 5000, maxPrice: 15000))
            .thenAnswer((_) async => mockPackages);

        final result = await mockPackageService.getPackagesByPriceRange(
            minPrice: 5000, maxPrice: 15000);

        expect(result, hasLength(2));
        expect(result.every((p) => p.price >= 5000 && p.price <= 15000), true);
      });

      test('should return empty list when no packages in range', () async {
        when(mockPackageService.getPackagesByPriceRange(
                minPrice: 1000, maxPrice: 2000))
            .thenAnswer((_) async => []);

        final result = await mockPackageService.getPackagesByPriceRange(
            minPrice: 1000, maxPrice: 2000);

        expect(result, isEmpty);
      });
    });

    group('getPackagesByTokenAmount', () {
      test('should return packages within token amount range', () async {
        final mockPackages = [
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
        ];

        when(mockPackageService.getPackagesByTokenAmount(
                minTokens: 500, maxTokens: 1500))
            .thenAnswer((_) async => mockPackages);

        final result = await mockPackageService.getPackagesByTokenAmount(
            minTokens: 500, maxTokens: 1500);

        expect(result, hasLength(2));
        expect(
            result.every((p) => p.totalTokens >= 500 && p.totalTokens <= 1500),
            true);
      });
    });

    group('getBestValuePackage', () {
      test('should return package with best value', () async {
        final mockPackage = TokenPackageModel(
          id: 'package_best',
          name: '최고 가성비 패키지',
          description: '1000 토큰',
          tokenAmount: 1000,
          price: 8000,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );

        when(mockPackageService.getBestValuePackage())
            .thenAnswer((_) async => mockPackage);

        final result = await mockPackageService.getBestValuePackage();

        expect(result, isNotNull);
        expect(result!.id, 'package_best');
        expect(result.pricePerToken, 8.0); // 8000 / 1000
      });

      test('should return null when no packages available', () async {
        when(mockPackageService.getBestValuePackage())
            .thenAnswer((_) async => null);

        final result = await mockPackageService.getBestValuePackage();

        expect(result, isNull);
      });
    });

    group('getPackagesUnderPrice', () {
      test('should return packages under specified price', () async {
        final mockPackages = [
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
        ];

        when(mockPackageService.getPackagesUnderPrice(15000))
            .thenAnswer((_) async => mockPackages);

        final result = await mockPackageService.getPackagesUnderPrice(15000);

        expect(result, hasLength(2));
        expect(result.every((p) => p.price <= 15000), true);
      });

      test('should return empty list when no packages under price', () async {
        when(mockPackageService.getPackagesUnderPrice(1000))
            .thenAnswer((_) async => []);

        final result = await mockPackageService.getPackagesUnderPrice(1000);

        expect(result, isEmpty);
      });
    });

    group('getPackagesWithBonus', () {
      test('should return packages with bonus tokens', () async {
        final mockPackages = [
          TokenPackageModel(
            id: 'package_1',
            name: '보너스 패키지',
            description: '1000 토큰 + 100 보너스',
            tokenAmount: 1000,
            price: 10000,
            bonusTokens: 100,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
          TokenPackageModel(
            id: 'package_2',
            name: '대보너스 패키지',
            description: '2000 토큰 + 500 보너스',
            tokenAmount: 2000,
            price: 20000,
            bonusTokens: 500,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
        ];

        when(mockPackageService.getPackagesWithBonus())
            .thenAnswer((_) async => mockPackages);

        final result = await mockPackageService.getPackagesWithBonus();

        expect(result, hasLength(2));
        expect(result.every((p) => p.bonusTokens != null && p.bonusTokens! > 0),
            true);
      });

      test('should return empty list when no packages have bonus', () async {
        when(mockPackageService.getPackagesWithBonus())
            .thenAnswer((_) async => []);

        final result = await mockPackageService.getPackagesWithBonus();

        expect(result, isEmpty);
      });
    });

    group('getPackagesByCurrency', () {
      test('should return packages by currency', () async {
        final mockPackages = [
          TokenPackageModel(
            id: 'package_krw',
            name: 'KRW 패키지',
            description: '1000 토큰',
            tokenAmount: 1000,
            price: 10000,
            currency: 'KRW',
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
          TokenPackageModel(
            id: 'package_usd',
            name: 'USD 패키지',
            description: '1000 토큰',
            tokenAmount: 1000,
            price: 9.99,
            currency: 'USD',
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
        ];

        when(mockPackageService.getPackagesByCurrency('KRW'))
            .thenAnswer((_) async => [mockPackages[0]]);
        when(mockPackageService.getPackagesByCurrency('USD'))
            .thenAnswer((_) async => [mockPackages[1]]);

        final krwPackages =
            await mockPackageService.getPackagesByCurrency('KRW');
        final usdPackages =
            await mockPackageService.getPackagesByCurrency('USD');

        expect(krwPackages, hasLength(1));
        expect(krwPackages[0].currency, 'KRW');
        expect(usdPackages, hasLength(1));
        expect(usdPackages[0].currency, 'USD');
      });
    });

    group('getPackageRecommendations', () {
      test('should return package recommendations based on user preferences',
          () async {
        final mockPackages = [
          TokenPackageModel(
            id: 'package_rec_1',
            name: '추천 패키지 1',
            description: '1000 토큰',
            tokenAmount: 1000,
            price: 10000,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
          TokenPackageModel(
            id: 'package_rec_2',
            name: '추천 패키지 2',
            description: '2000 토큰',
            tokenAmount: 2000,
            price: 20000,
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
        ];

        final preferences = {
          'maxPrice': 25000,
          'minTokens': 500,
          'preferredCurrency': 'KRW',
        };

        when(mockPackageService.getPackageRecommendations(preferences))
            .thenAnswer((_) async => mockPackages);

        final result =
            await mockPackageService.getPackageRecommendations(preferences);

        expect(result, hasLength(2));
        expect(result.every((p) => p.price <= 25000), true);
        expect(result.every((p) => p.totalTokens >= 500), true);
      });
    });

    group('getPackageComparison', () {
      test('should return package comparison data', () async {
        final mockComparison = {
          'packages': [
            {
              'id': 'package_1',
              'name': '기본 패키지',
              'pricePerToken': 10.0,
              'totalValue': 1000,
            },
            {
              'id': 'package_2',
              'name': '인기 패키지',
              'pricePerToken': 9.0,
              'totalValue': 1100,
            },
          ],
          'bestValue': 'package_2',
          'mostPopular': 'package_2',
        };

        when(mockPackageService
                .getPackageComparison(['package_1', 'package_2']))
            .thenAnswer((_) async => mockComparison);

        final result = await mockPackageService
            .getPackageComparison(['package_1', 'package_2']);

        expect(result['packages'], hasLength(2));
        expect(result['bestValue'], 'package_2');
        expect(result['mostPopular'], 'package_2');
      });
    });
  });
}

// Mock TokenPackageService for testing
class MockTokenPackageService implements TokenPackageService {
  @override
  Future<List<TokenPackageModel>> getActivePackages() async {
    return [];
  }

  @override
  Future<List<TokenPackageModel>> getPopularPackages() async {
    return [];
  }

  @override
  Future<TokenPackageModel?> getPackageById(String packageId) async {
    return null;
  }

  @override
  Future<List<TokenPackageModel>> getPackagesByPriceRange({
    double? minPrice,
    double? maxPrice,
  }) async {
    return [];
  }

  @override
  Future<List<TokenPackageModel>> getPackagesByTokenAmount({
    int? minTokens,
    int? maxTokens,
  }) async {
    return [];
  }

  @override
  Future<TokenPackageModel?> getBestValuePackage() async {
    return null;
  }

  @override
  Future<List<TokenPackageModel>> getPackagesUnderPrice(double maxPrice) async {
    return [];
  }

  @override
  Future<List<TokenPackageModel>> getPackagesWithBonus() async {
    return [];
  }

  @override
  Future<List<TokenPackageModel>> getPackagesByCurrency(String currency) async {
    return [];
  }

  @override
  Future<List<TokenPackageModel>> getPackageRecommendations(
      Map<String, dynamic> preferences) async {
    return [];
  }

  @override
  Future<Map<String, dynamic>> getPackageComparison(
      List<String> packageIds) async {
    return {};
  }
}
