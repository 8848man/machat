// 이미지 채팅과 텍스트 채팅을 하나로 병합하는 StreamProvider
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/common/providers/chat_room_id.dart';
import 'package:async/async.dart';

final mergedChatStreamProvider =
    StreamProvider.autoDispose<List<dynamic>>((ref) {
  final roomId = ref.watch(chatRoomIdProvider);
  if (roomId == '') {
    return const Stream.empty();
  }

  // 각각의 스트림
  final chatStream = FirebaseFirestore.instance
      .collection('chat_rooms')
      .doc(roomId)
      .collection('chat')
      .orderBy('createdAt', descending: false)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      final timestamp = data['createdAt'] as Timestamp?;
      return {
        'createdBy': data['createdBy'] ?? '',
        'createdAt':
            timestamp?.toDate().toString() ?? DateTime.now().toString(),
        'message': data['message'],
        'isMine': data['createdBy'] == 'currentUserId',
        'type': data['type'] ?? 'chat',
      };
    }).toList();
  });

  final imageStream = FirebaseFirestore.instance
      .collection('chat_rooms')
      .doc(roomId)
      .collection('images')
      .orderBy('createdAt', descending: false)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      final timestamp = data['createdAt'] as Timestamp?;
      return {
        'createdBy': data['createdBy'] ?? '',
        'createdAt':
            timestamp?.toDate().toString() ?? DateTime.now().toString(),
        'imageUrl': data['imageUrl'],
        'isMine': data['senderId'] == 'currentUserId',
        'type': data['type'] ?? 'image',
      };
    }).toList();
  });

  // 스트림 병합
  final mergedStream = StreamGroup.merge([chatStream, imageStream]);

  // mergedStream 사용
  return mergedStream.map((event) {
    final combinedList = event.toList(); // 바로 리스트로 변환 (expand 없이)

    // createdAt 기준으로 정렬
    combinedList.sort((a, b) {
      final aCreatedAt = a['createdAt'];
      final bCreatedAt = b['createdAt'];

      if (aCreatedAt is DateTime && bCreatedAt is DateTime) {
        return aCreatedAt.compareTo(bCreatedAt);
      }
      return 0;
    });

    return combinedList;
  });
});
