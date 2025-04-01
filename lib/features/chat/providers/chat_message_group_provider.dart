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
        'id': data['id'] ?? '',
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
        'id': data['id'] ?? '',
        'createdBy': data['createdBy'] ?? '',
        'createdAt':
            timestamp?.toDate().toString() ?? DateTime.now().toString(),
        'imageUrl': data['imageUrl'],
        'isMine': data['senderId'] == 'currentUserId',
        'type': data['type'] ?? 'image',
      };
    }).toList();
  });

  // 스트림 병합합
  // final mergedStream = StreamGroup.merge([chatStream, imageStream]);
  // final mergedStream = StreamGroup.merge([chatStream, imageStream])
  //     .distinct((previous, current) {
  //   // 두 리스트 길이가 다르면 중복이 아님
  //   if (previous.length != current.length) return false;

  //   // createdAt을 기준으로 Set 변환 후 비교
  //   final prevSet = previous
  //       .map((e) =>
  //           '${e['createdBy']}_${e['createdAt']}_${e['type']}_${e['data']}')
  //       .toSet();
  //   final currSet = current
  //       .map((e) =>
  //           '${e['createdBy']}_${e['createdAt']}_${e['type']}_${e['data']}')
  //       .toSet();

  //   // Set이 완전히 동일하면 중복으로 간주
  //   return prevSet.length == currSet.length && prevSet.containsAll(currSet);
  // });
  final mergedStream = StreamGroup.merge([chatStream, imageStream]);

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
    final uniqueList =
        {for (var item in combinedList) item['id']: item}.values.toList();

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
