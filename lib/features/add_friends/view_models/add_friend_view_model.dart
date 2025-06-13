import 'package:machat/features/add_friends/models/add_friend.dart';
import 'package:machat/features/add_friends/repository/add_friend_repository.dart';
import 'package:machat/features/common/models/user_data.dart';
import 'package:machat/features/snack_bar_manager/lib.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_friend_view_model.g.dart';

@riverpod
class AddFriendViewModel extends _$AddFriendViewModel {
  @override
  AddFriendModel build() {
    return const AddFriendModel(users: []);
  }

  Future<void> searchByEmail(String email) async {
    try {
      if (email.isEmpty) {
        state = const AddFriendModel(users: []);
        return;
      }

      final user = await ref.read(addFriendRepositoryProvider).read(email);
      if (user.isEmpty) {
        state = const AddFriendModel(users: []);
        return;
      }

      if (user.isNotEmpty) {
        state = AddFriendModel(users: [UserData.fromJson(user)]);
      }
    } catch (e) {
      SnackBarCaller().callSnackBar(ref, '이메일 검색 중 오류가 발생했습니다.');
      state = const AddFriendModel(users: []);
      return;
    }
  }

  Future<void> searchByNickname(String name) async {
    try {
      if (name.isEmpty) {
        state = const AddFriendModel(users: []);
        return;
      }

      final users =
          await ref.read(addFriendRepositoryProvider).readAll(searchId: name);

      if (users.isEmpty) {
        state = const AddFriendModel(users: []);
        return;
      }
      if (users.isNotEmpty) {
        state = AddFriendModel(users: users.map(UserData.fromJson).toList());
      }
    } catch (e) {
      SnackBarCaller().callSnackBar(ref, '닉네임 검색 중 오류가 발생했습니다.');
    }
  }

  void addFriend(String email) {}
}
