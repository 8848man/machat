import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/chat/models/chat.dart';
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
            'deletedTo': data['deletedTo'],
            'isDeletedForEveryone': data['isDeletedForEveryone'],
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
            'deletedTo': data['deletedTo'],
            'isDeletedForEveryone': data['isDeletedForEveryone'],
            'lastDoc': snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
          };
        })
        .toList()
        .reversed
        .toList(); // 시간순 정렬
  }

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
          'deletedTo': data['deletedTo'],
          'isDeletedForEveryone': data['isDeletedForEveryone'],
        };
      }).toList();

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

    // StreamGroup 패키지를 쓰시면 merge 가능
    return StreamGroup.merge([chatStream]).map((event) {
      // (지난 실행 맥락을 저장하는 로직은 ViewModel or StateNotifier에서 담당)
      // 여기서는 단순히 합쳐진 리스트를 반환
      return event;
    });
  }

  Future<void> deleteChatFromMyself({
    required String roomId,
    required String chatId,
    required String userId,
  }) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(roomId)
          .collection('chat')
          .doc(chatId);
      await docRef.update({
        'deletedTo': FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      print('error occured when interecting servers!');
    }
  }

  Future<void> deleteChatFromAll({
    required String roomId,
    required String chatId,
  }) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(roomId)
          .collection('chat')
          .doc(chatId);

      await docRef.update({
        'isDeletedForEveryone': true,
      });
    } catch (e) {
      print('error occured when interecting servers!');
    }
  }

  ////////// refactoring codes

  /// 📌 최신 30개 채팅 가져오기
  Future<ChatFetchResult> getInitialChats2(String roomId) async {
    final snapshot = await firestore
        .collection('chat_rooms')
        .doc(roomId)
        .collection('chat')
        .orderBy('createdAt', descending: true)
        .limit(30)
        .get();

    final chats = snapshot.docs
        .map((doc) => Chat.fromDocumentSnapshot(doc))
        .toList()
        .reversed
        .toList();

    final lastDoc = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

    return ChatFetchResult(chats: chats, lastDoc: lastDoc);
  }

  /// 📌 이전 채팅 가져오기 (무한스크롤용)
  Future<ChatFetchResult> getPreviousChats2({
    required String roomId,
    required DocumentSnapshot lastDoc,
    int limit = 30,
  }) async {
    final snapshot = await firestore
        .collection('chat_rooms')
        .doc(roomId)
        .collection('chat')
        .orderBy('createdAt', descending: true)
        .startAfterDocument(lastDoc)
        .limit(limit)
        .get();
    final chats = snapshot.docs
        .map((doc) => Chat.fromDocumentSnapshot(doc))
        .toList()
        .reversed
        .toList();

    final gettingLastDoc = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

    return ChatFetchResult(chats: chats, lastDoc: gettingLastDoc);
  }

  Stream<List<Chat>> subscribeToNewChats2(
    String roomId,
    DateTime entryTime,
  ) {
    if (roomId.isEmpty) return const Stream.empty();

    final Stream<List<Chat>> chatStream = firestore
        .collection('chat_rooms')
        .doc(roomId)
        .collection('chat')
        .orderBy('createdAt', descending: false)
        .startAfter([Timestamp.fromDate(entryTime)])
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Chat.fromDocumentSnapshot(doc))
            .toList());

    return StreamGroup.merge([chatStream]);
  }
}
