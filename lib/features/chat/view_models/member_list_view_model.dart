import 'package:machat/features/chat/repository/chat_member_repository.dart';
import 'package:machat/features/chat/view_models/chat_view_model.dart';
import 'package:machat/features/common/models/chat_room_data.dart';
import 'package:machat/features/common/models/user_data.dart';
import 'package:machat/features/common/providers/chat_room_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'member_list_view_model.g.dart';

@riverpod
class MemberListViewModel extends _$MemberListViewModel {
  @override
  Future<UserListModel> build() async {
    final ChatRoomData chatState =
        await ref.watch(chatViewModelProvider.future);
    List<String> memberIdList = chatState.members;

    if (memberIdList.isEmpty) {
      return await fetchMembers(memberIdList);
    }

    ref.watch(chatRoomIdProvider);
    return const UserListModel(
      friends: [],
    );
  }

  Future<UserListModel> fetchMembers(List<String> memberIdList) async {
    final String roomId = ref.read(chatRoomIdProvider);
    final members =
        await ref.watch(chatMemberRepository).readAll(searchId: roomId);
    return UserListModel(
        friends: members.map((member) => UserData.fromJson(member)).toList());
  }

  // RoomUserData getMember({
  //   required ChatRoomData data,
  // }) {
  //   List<RoomUserData> members =
  //   // 채팅방 정보와 보낸 사람 id를 비교해 이름을 가져옴
  //   for (RoomUserData element in data.membersHistory) {
  //     if (element.id == data.members[index]) {
  //       return element;
  //     }
  //   }

  //   return const RoomUserData(name: '알 수 없는 사용자');
  // }
}
