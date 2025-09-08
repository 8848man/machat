import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/common/interfaces/repository_service.dart';

final chatMemberRepository = Provider<RepositoryService>((ref) {
  return ChatRepository(ref);
});

class ChatRepository implements RepositoryService {
  final Ref ref;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ChatRepository(this.ref);

  Future<List<Map<String, dynamic>>> getAllMembers(String roomId) async {
    final chatRef = _firestore
        .collection('chat_rooms')
        .doc(roomId)
        .collection('members')
        .get();

    chatRef.then((snapshot) {
      if (snapshot.docs.isEmpty) {
        throw Exception('No members found in this chat room');
      }

      final List<Map<String, dynamic>> members =
          snapshot.docs.map((doc) => doc.data()).toList();
      return {'members': members};
    }).catchError((error) {
      throw Exception('Failed to fetch members: $error');
    });

    return [];
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
  Future<Map<String, dynamic>> read(String id) {
    // TODO: implement read
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> readAll({String? searchId}) async =>
      getAllMembers(searchId ?? '');

  @override
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> data) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
