part of '../lib.dart';

final floatingButtonRepositoryProvider = Provider<RepositoryService>((ref) {
  return FloatingButtonRepository();
});

class FloatingButtonRepository implements RepositoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> data) async {
    try {
      // Firestore에 "chat_rooms" 컬렉션에 새로운 채팅방 추가
      final chatRoomRef = _firestore.collection('chat_rooms').doc();

      await chatRoomRef.set({
        'roomId': chatRoomRef.id,
        'createdBy': data['userId'],
        'createdAt': FieldValue.serverTimestamp(),
        'members': [data['userId']], // 초기 멤버로 로그인한 사용자 포함
      });

      return {'success': true};
    } catch (e) {
      print('error Occured! $e');
      return {'success': false};
    }
  }

  @override
  Future<void> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> read(String id) {
    // TODO: implement read
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> readAll({String? searchId}) {
    // TODO: implement readAll
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> data) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
