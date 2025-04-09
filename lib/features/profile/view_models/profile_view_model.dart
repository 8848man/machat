import 'package:machat/features/common/models/user_data.dart';
import 'package:machat/features/common/view_models/chat_room_crud_view_model.dart';
import 'package:machat/features/common/view_models/friend_list_view_model.dart';
import 'package:machat/features/profile/providers/profile_user_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_view_model.g.dart';

@riverpod
class ProfileViewModel extends _$ProfileViewModel {
  @override
  Future<UserData> build() async {
    final UserData data = await initData();

    return data;
  }

  Future<UserData> initData() async {
    // 유저 데이터를 이미 가져왔을 경우,
    // 가지고 있는 상태 리턴
    final userState = ref.read(profileUserProvider);
    return userState;
  }

  void updateUserData(UserData user) {
    ref.read(profileUserProvider.notifier).update((state) => user);
  }

  void clearUserData() {
    ref
        .read(profileUserProvider.notifier)
        .update((state) => const UserData(name: '알 수 없는 사용자'));
  }

  Future<void> createOneToOneChat() async {
    final UserData userData = ref.read(profileUserProvider);
    await ref.read(chatRoomCrudViewModelProvider.notifier).createChatRoom(
          addingUsers: userData.toRoomUserData().copyWith(
                lastJoinedAt: DateTime.now().toString(),
              ),
          roomName: '${userData.name} 님과의 대화',
          type: ChatRoomType.oneToOne,
        );
  }

  Future<void> addFriend() async {
    final UserData userData = ref.read(profileUserProvider);
    ref.read(friendListViewModelProvider.notifier).addFriend(userData.toJson());
  }
}
