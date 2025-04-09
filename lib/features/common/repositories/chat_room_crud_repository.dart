import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/common/interfaces/repository_service.dart';

final chatRoomCrudProvider = Provider<RepositoryService>((ref) {
  return ChatRoomCrudRepository();
});

class ChatRoomCrudRepository implements RepositoryService {
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
        'members': [...data['members']], // 초기 멤버들
        'membersHistory': [...data['membersHistory']], // 초기 멤버 히스토리 갱신
        'name': data['name'],
        'type': data['type'],
      });

      return {'success': true};
    } catch (e) {
      print('error Occured! $e');
      return {'success': false};
    }
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
      final querySnapshot = await _firestore
          .collection('chat_rooms')
          // 오픈 채팅만 검색함
          .where('type', isEqualTo: 'open')
          .get();

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
