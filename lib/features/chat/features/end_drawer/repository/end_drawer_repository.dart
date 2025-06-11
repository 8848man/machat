import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/common/interfaces/repository_service.dart';
import 'package:machat/features/common/view_models/user_view_model.dart';
import 'package:machat/features/snack_bar_manager/lib.dart';

final memberCrudRepository = Provider<RepositoryService>((ref) {
  return MemberCrudRepository(ref: ref);
});

class MemberCrudRepository implements RepositoryService {
  final Ref ref;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  MemberCrudRepository({required this.ref});

  Future<Map<String, dynamic>> addMember(Map<String, dynamic> data) async {
    try {
      final currentUser = await ref.read(userViewModelProvider.future);
      await _firestore
          .collection('users')
          .doc(currentUser.id)
          .collection('members')
          .doc(data['id'])
          .set({
        'name': data['name'] ?? 'Unknown',
        'addedAt': FieldValue.serverTimestamp(),
        'status': 'added',
      });
      SnackBarCaller().callSnackBar(ref, '멤버 추가가 완료되었습니다');
      return {};
    } catch (e) {
      SnackBarCaller().callSnackBar(ref, '멤버 추가 실패 ${e.toString()}');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getMembers({String? searchId}) async {
    try {
      final chatRoomDoc =
          await _firestore.collection('chat_rooms').doc(searchId).get();

      if (chatRoomDoc.exists) {
        final data = chatRoomDoc.data();
        final memberIdList = List<String>.from(data?['members'] ?? []);
        // 이제 memberIdList는 List<String> 형태입니다.
        if (memberIdList.isEmpty) return [];

        // 2. 멤버들의 프로필 정보 가져오기 (batched get)
        final futures = memberIdList.map((id) {
          return _firestore.collection('users').doc(id).get();
        });

        final userDocs = await Future.wait(futures);

        // 3. UserData로 매핑
        final members = userDocs
            .where((doc) => doc.exists)
            .map((doc) => {
                  ...doc.data()!,
                  'id': doc.id, // id를 포함시켜줌 (ViewModel에서 필요할 수 있음)
                })
            .toList();
        return members;
      } else {
        // 문서가 존재하지 않을 때 처리
        throw Exception('Chat room not found');
      }
    } catch (e) {
      SnackBarCaller().callSnackBar(ref, '멤버 목록 가져오기 실패: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> deleteMember(String friendId) async {
    try {
      final currentUser = await ref.read(userViewModelProvider.future);
      await _firestore
          .collection('users')
          .doc(currentUser.id)
          .collection('members')
          .doc(friendId)
          .delete();

      SnackBarCaller().callSnackBar(ref, '멤버 삭제가 완료되었습니다.');
    } catch (e) {
      SnackBarCaller()
          .callSnackBar(ref, '멤버 삭제에 실패했습니다. 에러코드 : ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> data) async =>
      addMember(data);

  @override
  Future<void> delete(String id, {String? userId}) => deleteMember(id);

  @override
  Future<Map<String, dynamic>> read(String id) {
    // TODO: implement read
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> readAll({String? searchId}) =>
      getMembers(searchId: searchId);

  @override
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> data) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
