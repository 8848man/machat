import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatStreamRepositoryProvider = Provider<ChatStreamRepository>((ref) {
  return ChatStreamRepository();
});

class ChatStreamRepository {
  Stream<List<Map<String, dynamic>>> getChatStream(String roomId) {
    return FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(roomId)
        .collection('chat')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
