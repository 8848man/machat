import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/common/providers/chat_room_id.dart';

// chat stream을 관리하는 프로바이더
final chatStreamProvider = StreamProvider.autoDispose<List<dynamic>>((ref) {
  final roomId = ref.watch(chatRoomIdProvider);
  if (roomId == '') {
    return const Stream.empty();
  }

  return FirebaseFirestore.instance
      .collection('chat_rooms')
      .doc(roomId)
      .collection('chat')
      .orderBy('createdAt', descending: false)
      .snapshots()
      .map((snapshot) {
    return getChatData(snapshot);
  });
});

List<dynamic> getChatData(snapshot) {
  try {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      final timestamp = data['createdAt'] as Timestamp?;
      return {
        'createdBy': data['createdBy'] ?? '',
        // sendMessage할 때 찰나의 순간에 createdAt이 비어있기때문에
        // 대신 값 주입
        'createdAt':
            timestamp?.toDate().toString() ?? DateTime.now().toString(),
        'message': data['message'],
        'isMine': data['createdBy'] == 'currentUserId', // 유저 ID 비교},
      };
    }).toList();
  } catch (e) {
    throw e;
  }
}
