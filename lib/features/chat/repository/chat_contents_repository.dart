import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/networks/firestore_provider.dart';

final chatContentsRepositoryProvider = Provider<ChatContentsRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return ChatContentsRepository(firestore);
});

class ChatContentsRepository {
  final FirebaseFirestore firestore;

  ChatContentsRepository(this.firestore);

  Future<List<Map<String, dynamic>>> getInitialChats(String roomId) async {
    final snapshot = await firestore
        .collection('chat_rooms')
        .doc(roomId)
        .collection('chat')
        .orderBy('createdAt', descending: true)
        .limit(30)
        .get();

    return snapshot.docs
        .map((doc) {
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
            'imageUrl': data['imageUrl'] ?? '',
            'lastDoc': snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
          };
        })
        .toList()
        .reversed
        .toList(); // 시간순 정렬
  }

  Future<List<Map<String, dynamic>>> getPreviousChats({
    required String roomId,
    required DocumentSnapshot lastDoc, // 또는 createdAt Timestamp
    int limit = 30,
  }) async {
    final snapshot = await firestore
        .collection('chat_rooms')
        .doc(roomId)
        .collection('chat')
        .orderBy('createdAt', descending: true)
        .startAfterDocument(lastDoc) // ← 중복 없이 확실함
        .limit(limit)
        .get();
    return snapshot.docs
        .map((doc) {
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
            'imageUrl': data['imageUrl'] ?? '',
            'lastDoc': snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
          };
        })
        .toList()
        .reversed
        .toList(); // 시간순 정렬
  }

  // Stream<List<Map<String, dynamic>>> getMergedChatStream(
  //   String roomId,
  // ) {
  //   if (roomId.isEmpty) {
  //     return const Stream.empty();
  //   }

  //   final chatStream = firestore
  //       .collection('chat_rooms')
  //       .doc(roomId)
  //       .collection('chat')
  //       .orderBy('createdAt', descending: false)
  //       .snapshots()
  //       .map(_mapChatDocs);

  //   // final imageStream = firestore
  //   //     .collection('chat_rooms')
  //   //     .doc(roomId)
  //   //     .collection('images')
  //   //     .orderBy('createdAt', descending: false)
  //   //     .snapshots()
  //   //     .map(_mapImageDocs);

  //   // StreamGroup 패키지를 쓰시면 merge 가능
  //   return StreamGroup.merge([
  //     chatStream,
  //     // imageStream,
  //   ]).map((event) {
  //     // (지난 실행 맥락을 저장하는 로직은 ViewModel or StateNotifier에서 담당)
  //     // 여기서는 단순히 합쳐진 리스트를 반환
  //     return event;
  //   });
  // }

  List<Map<String, dynamic>> _mapChatDocs(QuerySnapshot snap) =>
      snap.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final ts = data['createdAt'] as Timestamp?;
        return {
          'id': data['id'] ?? '',
          'createdBy': data['createdBy'] ?? '',
          'createdAt': ts?.toDate().toString() ?? DateTime.now().toString(),
          'message': data['message'],
          'isMine': data['createdBy'] == 'currentUserId',
          'type': data['type'] ?? 'chat',
          'imageUrl': data['imageUrl'] ?? '',
        };
      }).toList();

  // List<Map<String, dynamic>> _mapImageDocs(QuerySnapshot snap) =>
  //     snap.docs.map((doc) {
  //       final data = doc.data() as Map<String, dynamic>;
  //       final ts = data['createdAt'] as Timestamp?;
  //       return {
  //         'id': data['id'] ?? '',
  //         'createdBy': data['createdBy'] ?? '',
  //         'createdAt': ts?.toDate().toString() ?? DateTime.now().toString(),
  //         'imageUrl': data['imageUrl'],
  //         'isMine': data['senderId'] == 'currentUserId',
  //         'type': data['type'] ?? 'image',
  //       };
  //     }).toList();

  Stream<List<Map<String, dynamic>>> subscribeToNewChats(
    String roomId,
    DateTime entryTime,
  ) {
    if (roomId.isEmpty) {
      return const Stream.empty();
    }

    final chatStream = firestore
        .collection('chat_rooms')
        .doc(roomId)
        .collection('chat')
        .orderBy('createdAt', descending: false)
        .startAfter([Timestamp.fromDate(entryTime)])
        .snapshots()
        .map(_mapChatDocs);

    // final imageStream = firestore
    //     .collection('chat_rooms')
    //     .doc(roomId)
    //     .collection('images')
    //     .orderBy('createdAt', descending: false)
    //     .startAfter([Timestamp.fromDate(entryTime)])
    //     .snapshots()
    //     .map(_mapImageDocs);

    // StreamGroup 패키지를 쓰시면 merge 가능
    return StreamGroup.merge([chatStream]).map((event) {
      // (지난 실행 맥락을 저장하는 로직은 ViewModel or StateNotifier에서 담당)
      // 여기서는 단순히 합쳐진 리스트를 반환
      return event;
    });
  }
}
