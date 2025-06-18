import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:machat/features/common/interfaces/repository_service.dart';
import 'package:machat/features/common/models/chat_list_model.dart';
import 'package:machat/features/common/models/chat_room_data.dart';
import 'package:machat/features/common/models/user_data.dart';
import 'package:machat/features/common/providers/chat_room_id.dart';
import 'package:machat/features/common/repositories/chat_room_crud_repository.dart';
import 'package:machat/features/common/utils/router_utils.dart';
import 'package:machat/features/common/view_models/user_view_model.dart';
import 'package:machat/features/snack_bar_manager/lib.dart';
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
    final ChatListModel data = ChatListModel(roomList: chatRooms);
    return data;
  }

  Future<List<ChatRoomData>> getChatRooms() async {
    final RepositoryService repository = ref.read(chatRoomCrudProvider);
    try {
      // 현재 사용자 ID 가져오기
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User is not logged in');
      }
      final String userId = currentUser.uid;

      // Repository 호출
      final List<Map<String, dynamic>> rawChatRooms =
          await repository.readAll();

      // Firestore 데이터를 ChatRoomData로 변환
      List<ChatRoomData> chatRooms = rawChatRooms.map((data) {
        return ChatRoomData.fromJson({
          'roomId': data['roomId'],
          'name': data['name'],
          'createdBy': data['createdBy'],
          'members': data['members'],
          'membersHistory': data['membersHistory'],
          'createdAt': (data['createdAt'] as Timestamp)
              .toDate()
              .toString(), // Timestamp를 String으로 변환
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
    final repository = ref.read(chatRoomCrudProvider);
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

  Future<void> enterChat(ChatRoomData data) async {
    final UserData userData = await ref.read(userViewModelProvider.future);
    final RoomUserData roomUserData = RoomUserData(
      id: userData.id,
      name: userData.name,
      email: userData.email,
      lastJoinedAt: DateTime.now().toString(),
    );
    // 로그인 되어있는지 확인
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      SnackBarCaller().callSnackBar(ref, '로그인 후 이용해주세요!');
      return;
    }
    // 이미 채팅방에 있을 경우의 처리
    if (data.members.contains(user.uid)) {
      SnackBarCaller().callSnackBar(ref, '이미 해당 채팅방에 소속되어있습니다.');
      return;
    }

    // firebase update할 데이터 셋
    final roomId = data.roomId;

    // 이전 멤버 히스토리 데이터를 할당할 리스트 생성
    List<dynamic> beforeHistory = [];

    // 이전 멤버 히스토리 데이터를 Json 형태로 할당
    for (RoomUserData i in data.membersHistory) {
      beforeHistory.add(i.toJson());
    }

    // 멤버에 추가
    final members = [...data.members, user.uid];
    final membersHistory = [...beforeHistory, roomUserData.toJson()];
    final Map<String, dynamic> sendData = {
      'members': members,
      'membersHistory': membersHistory,
    };

    // firebase update
    await ref.read(chatRoomCrudProvider).update(roomId, sendData);

    ref.read(chatRoomIdProvider.notifier).state = roomId;

    Router().goNamed(ref, RouterPath.chat, null);

    // final router = ref.read(goRouterProvider);
    // router.goNamed(RouterPath.home.name);
  }

  void goChat(String roomId) {
    ref.read(chatRoomIdProvider.notifier).state = roomId;
    final router = ref.read(goRouterProvider);
    router.goNamed(RouterPath.chat.name);
  }

  void goChatCreate() {
    final route = ref.read(goRouterProvider);

    route.goNamed(RouterPath.chatCreate.name);
  }

  Future<void> goChatRoomListPage() async {
    final route = ref.read(goRouterProvider);

    route.goNamed(RouterPath.chatList.name);
  }
}
