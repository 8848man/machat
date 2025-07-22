import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/token/features/token/interfaces/token_service.dart';
import 'package:machat/features/token/features/package/models/token_package_model.dart';

final tokenPackageRegisterProvider = Provider<IPackageRegisterService>((ref) {
  final firestore = FirebaseFirestore.instance;
  return PackageRegisterRepository(firestore: firestore);
});

class PackageRegisterRepository extends IPackageRegisterService {
  final FirebaseFirestore _firestore;

  static const String _tokenPackageCollection = 'token_packages';

  PackageRegisterRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<bool> deletePacakge(String id) async {
    try {
      await _firestore.collection(_tokenPackageCollection).doc(id).delete();
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TokenPackageModel> fetchPackageById(String id) async {
    try {
      final data =
          await _firestore.collection(_tokenPackageCollection).doc(id).get();

      return TokenPackageModel.fromFirestore(data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> registPackage(TokenPackageModel data) async {
    try {
      final docRef = _firestore.collection(_tokenPackageCollection).doc();
      final newData = data.copyWith(id: docRef.id);
      await docRef.set(newData.toJson());
      // TODO: implement registPackage
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> updatePacakge(TokenPackageModel data) async {
    try {
      await _firestore
          .collection(_tokenPackageCollection)
          .doc(data.id)
          .update(data.toJson());
    } catch (e) {
      rethrow;
    }
    // TODO: implement updatePacakge
    throw UnimplementedError();
  }
}
