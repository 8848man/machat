import 'package:machat/features/common/interfaces/repository_service.dart';
import 'package:machat/features/common/models/friends_model.dart';
import 'package:machat/features/common/models/user_data.dart';
import 'package:machat/features/common/providers/friend_list.dart';
import 'package:machat/features/common/repositories/friend_crud_repository.dart';
import 'package:machat/features/snack_bar_manager/lib.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'friend_list_view_model.g.dart';

@riverpod
class FriendListViewModel extends _$FriendListViewModel {
  @override
  Future<FriendListModel> build() async {
    ref.watch(friendListProvider);
    return await getFriends();
  }

  Future<void> addFriend(Map<String, dynamic> data) async {
    final RepositoryService repository = ref.read(friendCrudRepository);

    // 서버에 친구 추가 요청 → 응답으로 UserData 받는다고 가정
    await repository.create(data); // 타입: UserData

    // 서버에서 받은 응답을 UserData로 변환
    final UserData newFriend =
        UserData.fromJson(data); // Map<String, dynamic> -> UserData

    // 캐시에 바로 추가
    ref.read(friendListProvider.notifier).addFriend(newFriend);
  }

  Future<FriendListModel> getFriends() async {
    List<UserData> cachedFriends = getCachedFriends();
    if (cachedFriends.isNotEmpty) {
      return FriendListModel(friends: cachedFriends);
    }
    try {
      final RepositoryService repository = ref.read(friendCrudRepository);
      final List<Map<String, dynamic>> friends = await repository.readAll();

      final List<UserData> parsedFriends =
          friends.map(UserData.fromJson).toList();

      // 빈 친구 목록인 경우, 빈 리스트를 반환합니다.
      if (parsedFriends.isEmpty) {
        return const FriendListModel(friends: []);
      }
      // 친구 목록을 상태에 저장합니다.
      cacheFriends(parsedFriends);

      return FriendListModel(friends: parsedFriends);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteFriend(String friendId) async {
    final repository = ref.read(friendCrudRepository);
    await repository.delete(friendId);

    // 삭제 후 캐시에서도 제거
    ref.read(friendListProvider.notifier).removeById(friendId);
  }

  void cacheFriends(List<UserData> friends) {
    ref.read(friendListProvider.notifier).set(friends);
  }

  void deleteCachedFriends() {
    ref.read(friendListProvider.notifier).clear();
  }

  List<UserData> getCachedFriends() {
    return ref.read(friendListProvider.notifier).list;
  }
}
