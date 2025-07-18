import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:machat/features/token/features/package/interfaces/i_package_service.dart';
import '../models/token_package_model.dart';

/// Firebase 기반 토큰 패키지 서비스 구현체
class FirebaseTokenPackageService implements ITokenPackageService {
  final FirebaseFirestore _firestore;

  static const String _tokenPackageCollection = 'token_packages';

  FirebaseTokenPackageService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<TokenPackageModel>> getActivePackages() async {
    try {
      final querySnapshot = await _firestore
          .collection(_tokenPackageCollection)
          .where('isActive', isEqualTo: true)
          .orderBy('price', descending: false)
          .get();

      return querySnapshot.docs
          .map((doc) => TokenPackageModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get active packages: $e');
    }
  }

  @override
  Future<List<TokenPackageModel>> getPopularPackages() async {
    try {
      final querySnapshot = await _firestore
          .collection(_tokenPackageCollection)
          .where('isActive', isEqualTo: true)
          .where('isPopular', isEqualTo: true)
          .orderBy('price', descending: false)
          .get();

      return querySnapshot.docs
          .map((doc) => TokenPackageModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get popular packages: $e');
    }
  }

  @override
  Future<TokenPackageModel?> getPackageById(String packageId) async {
    try {
      final doc = await _firestore
          .collection(_tokenPackageCollection)
          .doc(packageId)
          .get();

      if (doc.exists) {
        return TokenPackageModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get package by id: $e');
    }
  }

  @override
  Future<List<TokenPackageModel>> getPackagesByPriceRange({
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      Query query = _firestore
          .collection(_tokenPackageCollection)
          .where('isActive', isEqualTo: true);

      if (minPrice != null) {
        query = query.where('price', isGreaterThanOrEqualTo: minPrice);
      }
      if (maxPrice != null) {
        query = query.where('price', isLessThanOrEqualTo: maxPrice);
      }

      final querySnapshot =
          await query.orderBy('price', descending: false).get();

      return querySnapshot.docs
          .map((doc) => TokenPackageModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get packages by price range: $e');
    }
  }

  @override
  Future<List<TokenPackageModel>> getPackagesByTokenAmount({
    int? minTokens,
    int? maxTokens,
  }) async {
    try {
      Query query = _firestore
          .collection(_tokenPackageCollection)
          .where('isActive', isEqualTo: true);

      if (minTokens != null) {
        query = query.where('tokenAmount', isGreaterThanOrEqualTo: minTokens);
      }
      if (maxTokens != null) {
        query = query.where('tokenAmount', isLessThanOrEqualTo: maxTokens);
      }

      final querySnapshot =
          await query.orderBy('tokenAmount', descending: false).get();

      return querySnapshot.docs
          .map((doc) => TokenPackageModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get packages by token amount: $e');
    }
  }

  @override
  Future<TokenPackageModel?> getBestValuePackage() async {
    try {
      final packages = await getActivePackages();

      if (packages.isEmpty) return null;

      packages.sort((a, b) => a.pricePerToken.compareTo(b.pricePerToken));
      return packages.first;
    } catch (e) {
      throw Exception('Failed to get best value package: $e');
    }
  }

  @override
  Future<List<TokenPackageModel>> getPackagesUnderPrice(double maxPrice) async {
    try {
      final querySnapshot = await _firestore
          .collection(_tokenPackageCollection)
          .where('isActive', isEqualTo: true)
          .where('price', isLessThanOrEqualTo: maxPrice)
          .orderBy('price', descending: false)
          .get();

      return querySnapshot.docs
          .map((doc) => TokenPackageModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get packages under price: $e');
    }
  }
}
