import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/common/interfaces/repository_service.dart';
import 'package:machat/features/snack_bar_manager/lib.dart';
import 'package:machat/networks/firestore_provider.dart';

final addFriendRepositoryProvider = Provider<RepositoryService>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return AddFriendRepository(ref, firestore);
});

class AddFriendRepository implements RepositoryService {
  final Ref ref;
  final FirebaseFirestore firestore;

  AddFriendRepository(this.ref, this.firestore);

  Future<Map<String, dynamic>> searchByEmail(String email) async {
    final snapshot = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return {};
    return snapshot.docs.first.data();
  }

  Future<List<Map<String, dynamic>>> searchByNickname(String? nickname) async {
    if (nickname == null || nickname.isEmpty) {
      SnackBarCaller().callSnackBar(ref, '닉네임을 입력해주세요.');
      return [];
    }
    final snapshot = await firestore
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: nickname)
        .where('name', isLessThan: '$nickname\uf8ff')
        .limit(20)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> data) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String id, {String? userId}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> read(String id) => searchByEmail(id);

  @override
  Future<List<Map<String, dynamic>>> readAll({String? searchId}) =>
      searchByNickname(searchId);

  @override
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> data) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
