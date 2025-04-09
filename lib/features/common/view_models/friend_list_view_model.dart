import 'package:machat/features/common/interfaces/repository_service.dart';
import 'package:machat/features/common/models/friends_model.dart';
import 'package:machat/features/common/models/user_data.dart';
import 'package:machat/features/common/providers/friend_list.dart';
import 'package:machat/features/common/repositories/friend_crud_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'friend_list_view_model.g.dart';

@riverpod
class FriendListViewModel extends _$FriendListViewModel {
  @override
  Future<FriendListModel> build() async {
    return await getFriends();
  }

  Future<void> addFriend(Map<String, dynamic> data) async {
    // 친구 추가 로직을 여기에 작성합니다.
    // 예를 들어, Firebase Firestore에 친구 요청을 추가하는 등의 작업을 수행할 수 있습니다.
    final RepositoryService repository = ref.read(friendCrudRepository);

    repository.create(data);
  }

  Future<FriendListModel> getFriends() async {
    // 친구 목록을 가져오는 로직을 여기에 작성합니다.
    // 예를 들어, Firebase Firestore에서 친구 목록을 가져오는 등의 작업을 수행할 수 있습니다.
    try {
      final RepositoryService repository = ref.read(friendCrudRepository);
      final List<Map<String, dynamic>> friends = await repository.readAll();

      final List<UserData> parsedFriends =
          friends.map(UserData.fromJson).toList();

      // 친구 목록을 상태에 저장합니다.
      ref.read(friendListProvider.notifier).update((state) => parsedFriends);

      return FriendListModel(friends: parsedFriends);
    } catch (e) {
      rethrow;
    }
  }
}
