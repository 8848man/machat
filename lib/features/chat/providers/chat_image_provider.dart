// 이미지 채팅 스트림을 관리하는 프로바이더
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/common/providers/chat_room_id.dart';

final chatImageStreamProvider =
    StreamProvider.autoDispose<List<dynamic>>((ref) {
  final roomId = ref.watch(chatRoomIdProvider);
  if (roomId == '') {
    return const Stream.empty();
  }

  return FirebaseFirestore.instance
      .collection('chat_rooms')
      .doc(roomId)
      .collection('images') // 이미지가 저장된 서브 컬렉션
      .orderBy('timestamp', descending: false)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      final timestamp = data['timestamp'] as Timestamp?;
      return {
        'createdBy': data['senderId'] ?? '',
        'createdAt':
            timestamp?.toDate().toString() ?? DateTime.now().toString(),
        'imageUrl': data['imageUrl'], // 이미지 URL 저장
        'isMine': data['senderId'] == 'currentUserId', // 유저 ID 비교
      };
    }).toList();
  });
});
