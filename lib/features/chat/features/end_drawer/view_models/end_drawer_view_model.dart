import 'package:machat/features/chat/features/end_drawer/repository/end_drawer_repository.dart';
import 'package:machat/features/common/interfaces/repository_service.dart';
import 'package:machat/features/common/models/user_data.dart';
import 'package:machat/features/common/providers/chat_room_id.dart';
import 'package:machat/features/common/providers/user_cache_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'end_drawer_view_model.g.dart';

@riverpod
class EndDrawerViewModel extends _$EndDrawerViewModel {
  @override
  Future<UserListModel> build() async {
    ref.watch(roomMemberListProvider);
    return await getMembers();
  }

  Future<void> addMember(Map<String, dynamic> data) async {
    final RepositoryService repository = ref.read(memberCrudRepository);

    // 서버에 친구 추가 요청 → 응답으로 UserData 받는다고 가정
    await repository.create(data); // 타입: UserData

    final UserData newMember =
        UserData.fromJson(data); // Map<String, dynamic> -> UserData

    // 캐시에 바로 추가
    ref.read(roomMemberListProvider.notifier).addUsers(newMember);
  }

  Future<UserListModel> getMembers() async {
    List<UserData> cachedMembers = getCachedMembers();
    if (cachedMembers.isNotEmpty) {
      return UserListModel(friends: cachedMembers);
    }
    try {
      final String roomId = ref.read(chatRoomIdProvider);
      final RepositoryService repository = ref.read(memberCrudRepository);
      final List<Map<String, dynamic>> friends =
          await repository.readAll(searchId: roomId);

      final List<UserData> parsedMembers =
          friends.map(UserData.fromJson).toList();

      // 빈 친구 목록인 경우, 빈 리스트를 반환합니다.
      if (parsedMembers.isEmpty) {
        return const UserListModel(friends: []);
      }
      // 친구 목록을 상태에 저장합니다.
      cacheMembers(parsedMembers);

      return UserListModel(friends: parsedMembers);
    } catch (e) {
      rethrow;
    }
  }
  Future<void> deleteMember(String friendId) async {
    final repository = ref.read(memberCrudRepository);
    await repository.delete(friendId);

    // 삭제 후 캐시에서도 제거
    ref.read(roomMemberListProvider.notifier).removeById(friendId);
  }

  void cacheMembers(List<UserData> friends) {
    ref.read(roomMemberListProvider.notifier).set(friends);
  }

  void deleteCachedMembers() {
    ref.read(roomMemberListProvider.notifier).clear();
  }

  List<UserData> getCachedMembers() {
    return ref.read(roomMemberListProvider.notifier).list;
  }
}
