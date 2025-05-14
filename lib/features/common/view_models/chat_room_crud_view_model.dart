import 'package:firebase_auth/firebase_auth.dart';
import 'package:machat/features/chat/providers/chat_room_name_provider.dart';
import 'package:machat/features/common/models/user_data.dart';
import 'package:machat/features/common/providers/chat_room_id.dart';
import 'package:machat/features/common/repositories/chat_room_crud_repository.dart';
import 'package:machat/features/common/view_models/user_view_model.dart';
import 'package:machat/router/lib.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'chat_room_crud_view_model.g.dart';

enum ChatRoomType {
  group('group'),
  oneToOne('oneToOne'),
  open('open');

  const ChatRoomType(this.type);

  final String type;
}

@riverpod
class ChatRoomCrudViewModel extends _$ChatRoomCrudViewModel {
  @override
  void build() {}

  Future<void> createChatRoom({
    required String roomName,
    RoomUserData? addingUsers,
    // 채팅방 타입. 기본값 그룹
    ChatRoomType type = ChatRoomType.group,
  }) async {
    try {
      final UserData userData = await ref.read(userViewModelProvider.future);
      final List<dynamic> membersHistory = [];
      final List<String> members = [];

      // 추가로 등록할 유저가 있을 경우 추가로 등록
      if (addingUsers != null) {
        membersHistory.add(addingUsers.toJson());
        members.add(addingUsers.id.toString());
      }
      // 현재 로그인된 유저 추가
      members.add(userData.id.toString());
      // 유저 히스토리에 추가
      membersHistory.add(
        RoomUserData(
          name: userData.name,
          id: userData.id,
          email: userData.email,
          lastJoinedAt: DateTime.now().toString(),
        ).toJson(),
      );

      // FirebaseAuth를 이용하여 현재 로그인된 사용자 ID 가져오기
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User is not logged in');
      }
      final userId = currentUser.uid;

      final Map<String, dynamic> qData = {
        'userId': userId,
        'name': roomName,
        'membersHistory': membersHistory,
        'members': members,
        'type': type.type, // 그룹 타입으로 설정
      };
      final ChatRoomCrudRepository repository = ref.read(chatRoomCrudProvider);

      // 일대일 채팅방의 경우 createOneToOneChatRoom 메서드 호출
      if (type == ChatRoomType.oneToOne) {
        final Map<String, dynamic> data = await repository.createOneToOneChat(
            data: qData, friendUid: addingUsers?.id ?? '');
        // 생성 후, 혹은 있을 경우 채팅방으로 이동
        goToChatRoom(data['chatRoomId'] ?? '', data['name'] ?? '채팅방');
      } else {
        // Repository의 create 메서드 호출
        await repository.create(qData);
      }

      // 성공 메시지
      print('Chat room created successfully!');
    } catch (e) {
      // 에러 처리
      print('Error creating chat room: $e');
    }
  }

  // 해당 채팅방으로 이동
  void goToChatRoom(String chatRoomId, String roomName) {
    final router = ref.read(goRouterProvider);
    ref.read(chatRoomIdProvider.notifier).state = chatRoomId;
    ref.read(chatRoomNameProvider.notifier).state = roomName;
    router.goNamed(RouterPath.chat.name);
  }
}
