import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:machat/features/chat_list/models/chat_list_model.dart';
import 'package:machat/features/chat_list/repository/chat_list_repository.dart';
import 'package:machat/features/common/models/chat_room_data.dart';
import 'package:machat/features/snack_bar_manager/lib.dart';
import 'package:machat/router/lib.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_list_view_model.g.dart';

@riverpod
class ChatListViewModel extends _$ChatListViewModel {
  List<ChatRoomData> chatRooms = [];
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
    final repository = ref.read(chatListRepositoryProvider);
    try {
      // 현재 사용자 ID 가져오기
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User is not logged in');
      }
      final userId = currentUser.uid;

      // Repository 호출
      final rawChatRooms = await repository.readAll();

      // Firestore 데이터를 ChatRoomData로 변환
      List<ChatRoomData> chatRooms = rawChatRooms.map((data) {
        return ChatRoomData.fromJson({
          'roomId': data['roomId'],
          'name': data['name'],
          'createdBy': data['createdBy'],
          'members': data['members'],
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

  Future<void> enterChat(ChatRoomData data) async {
    // 로그인 되어있는지 확인하는 함수
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      SnackBarCaller().callSnackBar(ref, '로그인 후 이용해주세요!');
      return;
    }
    // firebase update할 데이터 셋
    final roomId = data.roomId;
    final members = [...data.members, user.uid];
    final Map<String, dynamic> sendData = {
      'members': members,
    };

    // firebase update
    ref.read(chatListRepositoryProvider).update(roomId, sendData);

    final router = ref.read(goRouterProvider);
    router.goNamed(RouterPath.home.name);
  }
}
