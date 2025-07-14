import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:machat/features/token/repositories/token_package_repository.dart';

import 'token_package_repository_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
  QuerySnapshot,
  Query
])
void main() {
  group('FirebaseTokenPackageService', () {
    late FirebaseTokenPackageService packageService;
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference<Map<String, dynamic>> mockPackageCollection;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockPackageCollection = MockCollectionReference<Map<String, dynamic>>();

      when(mockFirestore.collection('token_packages'))
          .thenReturn(mockPackageCollection);

      packageService = FirebaseTokenPackageService(firestore: mockFirestore);
    });

    group('getActivePackages', () {
      test('should return list of active packages', () async {
        final mockPackages = [
          {
            'name': '기본 패키지',
            'description': '1000 토큰',
            'tokenAmount': 1000,
            'price': 10000,
            'currency': 'KRW',
            'isActive': true,
            'isPopular': false,
            'createdAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
            'updatedAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
          },
          {
            'name': '인기 패키지',
            'description': '5000 토큰 + 500 보너스',
            'tokenAmount': 5000,
            'price': 45000,
            'currency': 'KRW',
            'isActive': true,
            'isPopular': true,
            'bonusTokens': 500,
            'createdAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
            'updatedAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
          },
        ];

        final mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
        final mockDocs = mockPackages.map((data) {
          final mockDoc = MockDocumentSnapshot<Map<String, dynamic>>();
          when(mockDoc.id).thenReturn('package_${mockPackages.indexOf(data)}');
          when(mockDoc.data()).thenReturn(data);
          return mockDoc;
        }).toList();

        when(mockPackageCollection.where('isActive', isEqualTo: true))
            .thenReturn(mockPackageCollection);
        when(mockPackageCollection.orderBy('price', descending: false))
            .thenReturn(mockPackageCollection);
        when(mockPackageCollection.get()).thenAnswer((_) async =>
            mockQuerySnapshot as QuerySnapshot<Map<String, dynamic>>);
        when(mockQuerySnapshot.docs).thenReturn(
            mockDocs.cast<QueryDocumentSnapshot<Map<String, dynamic>>>());

        final result = await packageService.getActivePackages();

        expect(result, hasLength(2));
        expect(result[0].name, '기본 패키지');
        expect(result[1].name, '인기 패키지');
        expect(result[1].bonusTokens, 500);
      });

      test('should return empty list when no active packages', () async {
        final mockQuerySnapshot = MockQuerySnapshot();
        when(mockPackageCollection.where('isActive', isEqualTo: true))
            .thenReturn(mockPackageCollection);
        when(mockPackageCollection.orderBy('price', descending: false))
            .thenReturn(mockPackageCollection);
        when(mockPackageCollection.get()).thenAnswer((_) async =>
            mockQuerySnapshot as QuerySnapshot<Map<String, dynamic>>);
        when(mockQuerySnapshot.docs).thenReturn([]);

        final result = await packageService.getActivePackages();

        expect(result, isEmpty);
      });
    });

    group('getPopularPackages', () {
      test('should return list of popular packages', () async {
        final mockPackages = [
          {
            'name': '인기 패키지 1',
            'description': '1000 토큰',
            'tokenAmount': 1000,
            'price': 10000,
            'currency': 'KRW',
            'isActive': true,
            'isPopular': true,
            'createdAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
            'updatedAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
          },
        ];

        final mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
        final mockDocs = mockPackages.map((data) {
          final mockDoc = MockDocumentSnapshot<Map<String, dynamic>>();
          when(mockDoc.id).thenReturn('package_1');
          when(mockDoc.data()).thenReturn(data);
          return mockDoc;
        }).toList();

        when(mockPackageCollection.where('isActive', isEqualTo: true))
            .thenReturn(mockPackageCollection);
        when(mockPackageCollection.where('isPopular', isEqualTo: true))
            .thenReturn(mockPackageCollection);
        when(mockPackageCollection.orderBy('price', descending: false))
            .thenReturn(mockPackageCollection);
        when(mockPackageCollection.get()).thenAnswer((_) async =>
            mockQuerySnapshot as QuerySnapshot<Map<String, dynamic>>);
        when(mockQuerySnapshot.docs).thenReturn(
            mockDocs.cast<QueryDocumentSnapshot<Map<String, dynamic>>>());

        final result = await packageService.getPopularPackages();

        expect(result, hasLength(1));
        expect(result[0].name, '인기 패키지 1');
        expect(result[0].isPopular, true);
      });
    });

    group('getPackageById', () {
      test('should return package when found', () async {
        final mockData = {
          'name': '기본 패키지',
          'description': '1000 토큰',
          'tokenAmount': 1000,
          'price': 10000,
          'currency': 'KRW',
          'isActive': true,
          'isPopular': false,
          'createdAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
          'updatedAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
        };

        final mockDoc = MockDocumentSnapshot<Map<String, dynamic>>();
        when(mockDoc.exists).thenReturn(true);
        when(mockDoc.data()).thenReturn(mockData);
        when(mockDoc.id).thenReturn('package_123');

        final mockDocRef = MockDocumentReference<Map<String, dynamic>>();
        when(mockPackageCollection.doc('package_123')).thenReturn(mockDocRef);
        when(mockDocRef.get()).thenAnswer((_) async => mockDoc);

        final result = await packageService.getPackageById('package_123');

        expect(result, isNotNull);
        expect(result!.name, '기본 패키지');
        expect(result.tokenAmount, 1000);
        expect(result.price, 10000);
      });

      test('should return null when package not found', () async {
        final mockDoc = MockDocumentSnapshot<Map<String, dynamic>>();
        when(mockDoc.exists).thenReturn(false);

        final mockDocRef = MockDocumentReference<Map<String, dynamic>>();
        when(mockPackageCollection.doc('nonexistent')).thenReturn(mockDocRef);
        when(mockDocRef.get()).thenAnswer((_) async => mockDoc);

        final result = await packageService.getPackageById('nonexistent');

        expect(result, isNull);
      });
    });

    group('getPackagesByPriceRange', () {
      test('should return packages within price range', () async {
        final mockPackages = [
          {
            'name': '저가 패키지',
            'description': '500 토큰',
            'tokenAmount': 500,
            'price': 5000,
            'currency': 'KRW',
            'isActive': true,
            'createdAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
            'updatedAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
          },
          {
            'name': '중간 패키지',
            'description': '1000 토큰',
            'tokenAmount': 1000,
            'price': 10000,
            'currency': 'KRW',
            'isActive': true,
            'createdAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
            'updatedAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
          },
        ];

        final mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
        final mockDocs = mockPackages.map((data) {
          final mockDoc = MockDocumentSnapshot<Map<String, dynamic>>();
          when(mockDoc.id).thenReturn('package_${mockPackages.indexOf(data)}');
          when(mockDoc.data()).thenReturn(data);
          return mockDoc;
        }).toList();

        when(mockPackageCollection.where('isActive', isEqualTo: true))
            .thenReturn(mockPackageCollection);
        when(mockPackageCollection.where('price', isGreaterThanOrEqualTo: 5000))
            .thenReturn(mockPackageCollection);
        when(mockPackageCollection.where('price', isLessThanOrEqualTo: 15000))
            .thenReturn(mockPackageCollection);
        when(mockPackageCollection.orderBy('price', descending: false))
            .thenReturn(mockPackageCollection);
        when(mockPackageCollection.get())
            .thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn(
            mockDocs.cast<QueryDocumentSnapshot<Map<String, dynamic>>>());

        final result = await packageService.getPackagesByPriceRange(
          minPrice: 5000,
          maxPrice: 15000,
        );

        expect(result, hasLength(2));
        expect(result[0].price, 5000);
        expect(result[1].price, 10000);
      });
    });

    group('getPackagesByTokenAmount', () {
      test('should return packages within token amount range', () async {
        final mockPackages = [
          {
            'name': '소량 패키지',
            'description': '500 토큰',
            'tokenAmount': 500,
            'price': 5000,
            'currency': 'KRW',
            'isActive': true,
            'createdAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
            'updatedAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
          },
          {
            'name': '대량 패키지',
            'description': '2000 토큰',
            'tokenAmount': 2000,
            'price': 20000,
            'currency': 'KRW',
            'isActive': true,
            'createdAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
            'updatedAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
          },
        ];

        final mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
        final mockDocs = mockPackages.map((data) {
          final mockDoc = MockDocumentSnapshot<Map<String, dynamic>>();
          when(mockDoc.id).thenReturn('package_${mockPackages.indexOf(data)}');
          when(mockDoc.data()).thenReturn(data);
          return mockDoc;
        }).toList();

        when(mockPackageCollection.where('isActive', isEqualTo: true))
            .thenReturn(mockPackageCollection);
        when(mockPackageCollection.where('tokenAmount',
                isGreaterThanOrEqualTo: 500))
            .thenReturn(mockPackageCollection);
        when(mockPackageCollection.where('tokenAmount',
                isLessThanOrEqualTo: 2000))
            .thenReturn(mockPackageCollection);
        when(mockPackageCollection.orderBy('tokenAmount', descending: false))
            .thenReturn(mockPackageCollection);
        when(mockPackageCollection.get())
            .thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn(
            mockDocs.cast<QueryDocumentSnapshot<Map<String, dynamic>>>());

        final result = await packageService.getPackagesByTokenAmount(
          minTokens: 500,
          maxTokens: 2000,
        );

        expect(result, hasLength(2));
        expect(result[0].tokenAmount, 500);
        expect(result[1].tokenAmount, 2000);
      });
    });

    group('getBestValuePackage', () {
      test('should return package with best value (lowest price per token)',
          () async {
        final mockPackages = [
          {
            'name': '고가 패키지',
            'description': '1000 토큰',
            'tokenAmount': 1000,
            'price': 15000,
            'currency': 'KRW',
            'isActive': true,
            'createdAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
            'updatedAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
          },
          {
            'name': '저가 패키지',
            'description': '1000 토큰',
            'tokenAmount': 1000,
            'price': 10000,
            'currency': 'KRW',
            'isActive': true,
            'createdAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
            'updatedAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
          },
        ];

        final mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
        final mockDocs = mockPackages.map((data) {
          final mockDoc = MockDocumentSnapshot<Map<String, dynamic>>();
          when(mockDoc.id).thenReturn('package_${mockPackages.indexOf(data)}');
          when(mockDoc.data()).thenReturn(data);
          return mockDoc;
        }).toList();

        when(mockPackageCollection.where('isActive', isEqualTo: true))
            .thenReturn(mockPackageCollection);
        when(mockPackageCollection.orderBy('price', descending: false))
            .thenReturn(mockPackageCollection);
        when(mockPackageCollection.get())
            .thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn(
            mockDocs.cast<QueryDocumentSnapshot<Map<String, dynamic>>>());

        final result = await packageService.getBestValuePackage();

        expect(result, isNotNull);
        expect(result!.name, '저가 패키지');
        expect(result.price, 10000);
      });

      test('should return null when no active packages', () async {
        final mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
        when(mockPackageCollection.where('isActive', isEqualTo: true))
            .thenReturn(mockPackageCollection);
        when(mockPackageCollection.orderBy('price', descending: false))
            .thenReturn(mockPackageCollection);
        when(mockPackageCollection.get())
            .thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([]);

        final result = await packageService.getBestValuePackage();

        expect(result, isNull);
      });
    });

    group('getPackagesUnderPrice', () {
      test('should return packages under specified price', () async {
        final mockPackages = [
          {
            'name': '저가 패키지',
            'description': '500 토큰',
            'tokenAmount': 500,
            'price': 5000,
            'currency': 'KRW',
            'isActive': true,
            'createdAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
            'updatedAt': Timestamp.fromDate(DateTime(2024, 1, 1)),
          },
        ];

        final mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
        final mockDocs = mockPackages.map((data) {
          final mockDoc = MockDocumentSnapshot<Map<String, dynamic>>();
          when(mockDoc.id).thenReturn('package_1');
          when(mockDoc.data()).thenReturn(data);
          return mockDoc;
        }).toList();

        when(mockPackageCollection.where('isActive', isEqualTo: true))
            .thenReturn(mockPackageCollection);
        when(mockPackageCollection.where('price', isLessThanOrEqualTo: 10000))
            .thenReturn(mockPackageCollection);
        when(mockPackageCollection.orderBy('price', descending: false))
            .thenReturn(mockPackageCollection);
        when(mockPackageCollection.get())
            .thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn(
            mockDocs.cast<QueryDocumentSnapshot<Map<String, dynamic>>>());

        final result = await packageService.getPackagesUnderPrice(10000);

        expect(result, hasLength(1));
        expect(result[0].name, '저가 패키지');
        expect(result[0].price, 5000);
      });
    });
  });
}
