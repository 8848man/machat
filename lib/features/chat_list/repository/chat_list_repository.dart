import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:machat/features/common/interfaces/repository_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final chatListRepositoryProvider = Provider<RepositoryService>((ref) {
  return ChatListRepository();
});

class ChatListRepository implements RepositoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
  Future<Map<String, dynamic>> read(String id) {
    // TODO: implement read
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> readAll({String? searchId}) async {
    try {
      final querySnapshot = await _firestore.collection('chat_rooms').get();

      // Firestore의 raw 데이터를 반환
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Failed to fetch chat rooms: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> update(
      String id, Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance.collection('chat_rooms').doc(id).update({
        'members': data['members'],
        'membersHistory': data['membersHistory'],
      });
      return {'success': true};
    } catch (e) {
      print(e);
      return {'success': false};
    }
  }
}
