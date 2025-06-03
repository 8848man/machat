import 'package:machat/features/chat/repository/chat_member_repository.dart';
import 'package:machat/features/common/models/user_data.dart';
import 'package:machat/features/common/providers/chat_room_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'member_list_view_model.g.dart';

@riverpod
class MemberListViewModel extends _$MemberListViewModel {
  @override
  Future<UserListModel> build() async {
    ref.watch(chatRoomIdProvider);
    return const UserListModel(
      friends: [],
    );
  }

  Future<UserListModel> fetchMembers() async {
    final String roomId = ref.read(chatRoomIdProvider);
    final members =
        await ref.watch(chatMemberRepository).readAll(searchId: roomId);
    return UserListModel(
        friends: members.map((member) => UserData.fromJson(member)).toList());
  }
}
