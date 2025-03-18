import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/common/interfaces/repository_service.dart';

final chatRoomRepositoryProvider = Provider<RepositoryService>((ref) {
  return ChatRoomRepository();
});

class ChatRoomRepository implements RepositoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> data) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String roomId, {String? userId}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> read(String id) async {
    try {
      final querySnapshot =
          await _firestore.collection('chat_rooms').doc(id).get();

      // Firestore의 raw 데이터를 반환
      return querySnapshot.data()!;
    } catch (e) {
      throw Exception('Failed to fetch chat rooms: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> readAll({String? searchId}) async {
    try {
      final querySnapshot = await _firestore
          .collection('chat_rooms')
          .where('members', arrayContains: searchId)
          .get();

      // Firestore의 raw 데이터를 반환
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Failed to fetch chat rooms: $e');
    }
  }

  // 채팅방 업데이트
  @override
  Future<Map<String, dynamic>> update(
      String id, Map<String, dynamic> data) async {
    try {
      // Firestore에 "chat_rooms" 컬렉션에 새로운 채팅방 추가
      final chatRoomRef =
          _firestore.collection('chat_rooms').doc(data['roomId']);

      await chatRoomRef.update({
        'members': data['members'], // 멤버 변경
      });

      return {'success': true};
    } catch (e) {
      print('error Occured! $e');
      return {'success': false};
    }
  }
}
