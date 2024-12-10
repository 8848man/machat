import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/common/interfaces/repository_service.dart';

final chatRepositoryProvider = Provider<RepositoryService>((ref) {
  return ChatRepository();
});

class ChatRepository implements RepositoryService {
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> data) async {
    final chatRef = FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(data['roomId'])
        .collection('chat')
        .doc();

    await chatRef.set({
      'message': data['message'],
      'createdBy': data['userId'],
      'createdAt': FieldValue.serverTimestamp(),
    });
    return {};
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
