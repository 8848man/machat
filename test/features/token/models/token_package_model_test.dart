import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:machat/features/token/models/token_package_model.dart';

void main() {
  group('TokenPackageModel', () {
    test('should create TokenPackageModel with required fields', () {
      final package = TokenPackageModel(
        id: 'package_123',
        name: '기본 패키지',
        description: '1000 토큰',
        tokenAmount: 1000,
        price: 10000,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      expect(package.id, 'package_123');
      expect(package.name, '기본 패키지');
      expect(package.description, '1000 토큰');
      expect(package.tokenAmount, 1000);
      expect(package.price, 10000);
      expect(package.currency, 'KRW'); // default value
      expect(package.isActive, true); // default value
      expect(package.isPopular, false); // default value
    });

    test('should create TokenPackageModel with all fields', () {
      final package = TokenPackageModel(
        id: 'package_123',
        name: '인기 패키지',
        description: '5000 토큰 + 500 보너스',
        tokenAmount: 5000,
        price: 45000,
        currency: 'KRW',
        isActive: true,
        isPopular: true,
        bonusTokens: 500,
        imageUrl: 'https://example.com/image.png',
        metadata: {'category': 'popular'},
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      expect(package.bonusTokens, 500);
      expect(package.imageUrl, 'https://example.com/image.png');
      expect(package.metadata!['category'], 'popular');
    });

    test('should create TokenPackageModel from Firestore document', () {
      final mockData = {
        'name': '기본 패키지',
        'description': '1000 토큰',
        'tokenAmount': 1000,
        'price': 10000,
        'currency': 'KRW',
        'isActive': true,
        'isPopular': false,
        'bonusTokens': 100,
        'imageUrl': 'https://example.com/image.png',
        'metadata': {'category': 'basic'},
        'createdAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
        'updatedAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
      };

      final mockDoc = MockDocumentSnapshot('package_123', mockData);
      final package = TokenPackageModel.fromFirestore(mockDoc);

      expect(package.id, 'package_123');
      expect(package.name, '기본 패키지');
      expect(package.tokenAmount, 1000);
      expect(package.price, 10000);
      expect(package.bonusTokens, 100);
      expect(package.imageUrl, 'https://example.com/image.png');
      expect(package.metadata!['category'], 'basic');
    });

    test('should convert to Firestore format', () {
      final package = TokenPackageModel(
        id: 'package_123',
        name: '기본 패키지',
        description: '1000 토큰',
        tokenAmount: 1000,
        price: 10000,
        bonusTokens: 100,
        metadata: {'category': 'basic'},
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      final firestoreData = package.toFirestore();

      expect(firestoreData['name'], '기본 패키지');
      expect(firestoreData['tokenAmount'], 1000);
      expect(firestoreData['price'], 10000);
      expect(firestoreData['bonusTokens'], 100);
      expect(firestoreData['metadata']['category'], 'basic');
      expect(firestoreData['createdAt'], isA<Timestamp>());
    });

    test('should calculate total tokens correctly', () {
      final packageWithBonus = TokenPackageModel(
        id: 'package_123',
        name: '보너스 패키지',
        description: '1000 토큰 + 100 보너스',
        tokenAmount: 1000,
        price: 10000,
        bonusTokens: 100,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      final packageWithoutBonus = TokenPackageModel(
        id: 'package_124',
        name: '일반 패키지',
        description: '1000 토큰',
        tokenAmount: 1000,
        price: 10000,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      expect(packageWithBonus.totalTokens, 1100);
      expect(packageWithoutBonus.totalTokens, 1000);
    });

    test('should display correct price format', () {
      final krwPackage = TokenPackageModel(
        id: 'package_123',
        name: 'KRW 패키지',
        description: '1000 토큰',
        tokenAmount: 1000,
        price: 10000,
        currency: 'KRW',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      final usdPackage = TokenPackageModel(
        id: 'package_124',
        name: 'USD 패키지',
        description: '1000 토큰',
        tokenAmount: 1000,
        price: 9.99,
        currency: 'USD',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      expect(krwPackage.displayPrice, '₩10000');
      expect(usdPackage.displayPrice, '\$9.99');
    });

    test('should calculate price per token correctly', () {
      final package = TokenPackageModel(
        id: 'package_123',
        name: '테스트 패키지',
        description: '1000 토큰 + 100 보너스',
        tokenAmount: 1000,
        price: 10000,
        bonusTokens: 100,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      // 10000 / 1100 = 9.09...
      expect(package.pricePerToken, closeTo(9.09, 0.01));
    });

    test('should display bonus correctly', () {
      final packageWithBonus = TokenPackageModel(
        id: 'package_123',
        name: '보너스 패키지',
        description: '1000 토큰 + 100 보너스',
        tokenAmount: 1000,
        price: 10000,
        bonusTokens: 100,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      final packageWithoutBonus = TokenPackageModel(
        id: 'package_124',
        name: '일반 패키지',
        description: '1000 토큰',
        tokenAmount: 1000,
        price: 10000,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      expect(packageWithBonus.bonusDisplay, '+100 보너스');
      expect(packageWithoutBonus.bonusDisplay, null);
    });

    test('should create copy with updated values', () {
      final original = TokenPackageModel(
        id: 'package_123',
        name: '기본 패키지',
        description: '1000 토큰',
        tokenAmount: 1000,
        price: 10000,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      final updated = original.copyWith(
        name: '수정된 패키지',
        price: 15000,
        bonusTokens: 100,
      );

      expect(updated.name, '수정된 패키지');
      expect(updated.price, 15000);
      expect(updated.bonusTokens, 100);
      expect(updated.tokenAmount, 1000); // unchanged
      expect(updated.description, '1000 토큰'); // unchanged
    });

    test('should handle zero total tokens gracefully', () {
      final package = TokenPackageModel(
        id: 'package_123',
        name: '무료 패키지',
        description: '0 토큰',
        tokenAmount: 0,
        price: 0,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      expect(package.totalTokens, 0);
      expect(package.pricePerToken, 0);
    });
  });
}

// Mock DocumentSnapshot for testing
// ignore: subtype_of_sealed_class
class MockDocumentSnapshot implements DocumentSnapshot {
  @override
  final String id;
  final Map<String, dynamic> _mockData;

  MockDocumentSnapshot(this.id, this._mockData);

  @override
  bool get exists => true;

  @override
  @override
  Map<String, dynamic> data() => _mockData;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
