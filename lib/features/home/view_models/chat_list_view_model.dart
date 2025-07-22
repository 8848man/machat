import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:machat/features/chat/providers/chat_room_name_provider.dart';
import 'package:machat/features/common/models/chat_list_model.dart';
import 'package:machat/features/common/models/chat_room_data.dart';
import 'package:machat/features/common/providers/chat_room_id.dart';
import 'package:machat/features/common/providers/view_model_disposer.dart';
import 'package:machat/features/home/repositories/chat_room_repository.dart';
import 'package:machat/features/snack_bar_manager/lib.dart';
import 'package:machat/router/lib.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_list_view_model.g.dart';

@riverpod
class ChatListViewModel extends _$ChatListViewModel {
  @override
  Future<ChatListModel> build() async {
    // 외부의 ViewModelDisposerProvider를 사용하여 초기화
    ref.watch(viewModelDisposerProvider);
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

      if (roomData.members.length == 1) {
        // 방에 나만 남아있다면 방 삭제
        repository.delete(roomData.roomId);
      } else {
        repository.update(roomData.roomId, data);
      }

      SnackBarCaller().callSnackBar(ref, '채팅방이 삭제되었습니다.');

      update((state) async {
        final newChatRoom = await getChatRooms();

        return state.copyWith(roomList: newChatRoom);
      });
    } catch (e) {
      // 에러 처리
      print('Error fetching chat rooms: $e');
      return;
    }
  }

  void goChat(String roomId, String? roomName) {
    ref.read(chatRoomIdProvider.notifier).state = roomId;
    // 방 이름을 상태에 저장
    // 방 이름이 null인 경우 기본값으로 '채팅방' 사용
    ref.read(chatRoomNameProvider.notifier).state = roomName ?? '채팅방';
    final router = ref.read(goRouterProvider);
    router.pushNamed(RouterPath.chat.name);
  }

  void goLogin() {
    final router = ref.read(goRouterProvider);
    router.goNamed(RouterPath.login.name);
  }
}
