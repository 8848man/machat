import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:machat/features/common/models/chat_list_model.dart';
import 'package:machat/features/common/models/chat_room_data.dart';
import 'package:machat/features/common/providers/chat_room_id.dart';
import 'package:machat/features/home/repositories/chat_room_repository.dart';
import 'package:machat/router/lib.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_list_view_model.g.dart';

@riverpod
class ChatListViewModel extends _$ChatListViewModel {
  @override
  Future<ChatListModel> build() async {
    final ChatListModel data = await initData();

    return data;
  }

  Future<ChatListModel> initData() async {
    final List<ChatRoomData> chatRooms = await getChatRooms();
    return ChatListModel(roomList: chatRooms);
  }

  Future<List<ChatRoomData>> getChatRooms() async {
    final repository = ref.read(chatRoomRepositoryProvider);
    try {
      // 현재 사용자 ID 가져오기
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User is not logged in');
      }
      final userId = currentUser.uid;

      // Repository 호출
      final rawChatRooms = await repository.readAll(searchId: userId);

      // Firestore 데이터를 ChatRoomData로 변환
      List<ChatRoomData> chatRooms = rawChatRooms.map((data) {
        return ChatRoomData.fromJson({
          'roomId': data['roomId'],
          'name': data['name'],
          'createdBy': data['createdBy'],
          'members': data['members'],
          'createdAt': (data['createdAt'] as Timestamp)
              .toDate()
              .toString(), // Timestamp를 DateTime으로 변환
          'isMine': data['createdBy'] == userId, // 내가 만든 방인지 추가
        });
      }).toList();

      return chatRooms;
    } catch (e) {
      // 에러 처리
      print('Error fetching chat rooms: $e');
      return [];
    }
  }

  Future<void> deleteChatRoom(ChatRoomData roomData) async {
    final repository = ref.read(chatRoomRepositoryProvider);
    try {
      // 현재 사용자 ID 가져오기
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User is not logged in');
      }
      final userId = currentUser.uid;

      // 방 멤버에서 현재 사용자 제거
      final List<String> newMembers = roomData.members
          .where((element) => element != userId)
          .toList(); // 현재 사용자를 제외한 멤버 리스트

      final data = roomData.copyWith(members: newMembers).toJson();

      // Repository 호출
      await repository.update(roomData.roomId, data);
    } catch (e) {
      // 에러 처리
      print('Error fetching chat rooms: $e');
      return;
    }
  }

  void goChat(String roomId) {
    ref.read(chatRoomIdProvider.notifier).state = roomId;
    final router = ref.read(goRouterProvider);
    router.goNamed(RouterPath.chat.name);
  }
}
