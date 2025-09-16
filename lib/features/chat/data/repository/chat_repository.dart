import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/common/interfaces/repository_service.dart';

final chatRepositoryProvider = Provider<RepositoryService>((ref) {
  return ChatRepository(ref);
});

class ChatRepository implements RepositoryService {
  final Ref ref;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ChatRepository(this.ref);
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> data) async {
    final chatRef = _firestore
        .collection('chat_rooms')
        .doc(data['roomId'])
        .collection('chat')
        .doc();

    await chatRef.set({
      'id': chatRef.id,
      'type': 'chat',
      'message': data['message'],
      'createdBy': data['userId'],
      'createdAt': FieldValue.serverTimestamp(),
    });
    return {};
  }

  @override
  Future<void> delete(String id, {String? userId}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> read(String id) async {
    try {
      final doc = await _firestore.collection('chat_rooms').doc(id).get();

      if (!doc.exists) {
        throw Exception('Chat room not found');
      }

      return doc.data()!;
    } catch (e) {
      throw Exception('Chat room not found');
    }
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
