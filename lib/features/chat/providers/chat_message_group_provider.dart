// 이미지 채팅과 텍스트 채팅을 하나로 병합하는 StreamProvider
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/common/providers/chat_room_id.dart';
import 'package:async/async.dart';

// 이전 채팅 상태 저장 프로바이더
final previousChatStateProvider =
    StateProvider<List<Map<String, dynamic>>>((ref) {
  ref.watch(chatRoomIdProvider);
  return [];
});

final AutoDisposeStreamProvider<List<dynamic>> mergedChatStreamProvider =
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
  final mergedStream =
      StreamGroup.merge([chatStream, imageStream]).map((event) {
    return event;
  }).distinct((previous, current) {
    // previous와 current는 각각 List<Map<String, dynamic>> 형태
    for (var prevItem in previous) {
      for (var currItem in current) {
        // prevItem과 currItem의 createdAt을 비교하여 중복되는지 확인
        if (prevItem['createdAt'] == currItem['createdAt']) {
          return true; // 중복된 항목이 있을 경우 true 반환 (중복되지 않은 항목 그대로 반환)
        }
      }
    }
    return false; // 중복되지 않으면 false 반환 (중복항목 제거)
  });

  // mergedStream 사용
  return mergedStream.map((event) {
    // 이전 데이터를 가져옴
    final previousEvent = ref.read(previousChatStateProvider);
    // 가져온 후 이전 데이터 프로바이더 리셋
    ref.read(previousChatStateProvider.notifier).state = [];

    // 새로운 데이터가 있으면 기존 데이터와 병합
    final combinedList = [...previousEvent, ...event];

    // 작성자, 작성 시간, 아이템 종류로
    // 중복된 데이터 필터링
    // 없을 경우 데이터가 2개씩 출력됨
    final uniqueList = {
      for (var item in combinedList)
        '${item['createdBy']}_${item['createdAt'].substring(0, 18)}_${item['type']}':
            item
    }.values.toList();

    // createdAt 기준으로 정렬
    uniqueList.sort((a, b) {
      final String aCreatedAt = a['createdAt'];
      final String bCreatedAt = b['createdAt'];

      return aCreatedAt.compareTo(bCreatedAt);
    });

    // 상태 업데이트
    ref.read(previousChatStateProvider.notifier).state = uniqueList;

    return uniqueList;
  });
});
