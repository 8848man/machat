import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/common/interfaces/repository_service.dart';
import 'package:machat/features/common/view_models/user_view_model.dart';
import 'package:machat/features/snack_bar_manager/lib.dart';

final friendCrudRepository = Provider<RepositoryService>((ref) {
  return FriendCrudRepository(ref: ref);
});

class FriendCrudRepository implements RepositoryService {
  final Ref ref;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FriendCrudRepository({required this.ref});

  Future<Map<String, dynamic>> addFriend(Map<String, dynamic> data) async {
    try {
      final currentUser = await ref.read(userViewModelProvider.future);
      await _firestore
          .collection('users')
          .doc(currentUser.id)
          .collection('friends')
          .doc(data['id'])
          .set({
        'name': data['name'] ?? 'Unknown',
        'addedAt': FieldValue.serverTimestamp(),
        'status': 'added',
      });
      return {};
    } catch (e) {
      SnackBarCaller().callSnackBar(ref, '친구 추가 실패 ${e.toString()}');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getFriends() async {
    final currentUser = await ref.read(userViewModelProvider.future);
    // 1. 내 친구 목록 가져오기
    final friendsSnapshot = await _firestore
        .collection('users')
        .doc(currentUser.id)
        .collection('friends')
        .get();

    final friendIds = friendsSnapshot.docs.map((doc) => doc.id).toList();

    if (friendIds.isEmpty) return [];

    // 2. 친구들의 프로필 정보 가져오기 (batched get)
    final futures = friendIds.map((id) {
      return _firestore.collection('users').doc(id).get();
    });

    final userDocs = await Future.wait(futures);

    // 3. UserData로 매핑
    final friends = userDocs
        .where((doc) => doc.exists)
        .map((doc) => {
              ...doc.data()!,
              'id': doc.id, // id를 포함시켜줌 (ViewModel에서 필요할 수 있음)
            })
        .toList();

    return friends;
  }

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> data) async =>
      addFriend(data);

  @override
  Future<void> delete(String id, {String? userId}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> read(String id) {
    // TODO: implement read
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> readAll({String? searchId}) =>
      getFriends();

  @override
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> data) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
