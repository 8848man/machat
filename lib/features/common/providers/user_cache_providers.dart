import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/common/models/user_data.dart';

class UserCacheNotifier extends StateNotifier<Map<String, dynamic>> {
  UserCacheNotifier() : super({});

  void addCache(String key, dynamic value) {
    state = {...state, key: value};
  }

  Future<void> clearCache() async {
    state = {};
  }
}

final userCacheProvider =
    StateNotifierProvider<UserCacheNotifier, Map<String, dynamic>>(
  (ref) => UserCacheNotifier(),
);

class UserListNotifier extends StateNotifier<List<UserData>> {
  UserListNotifier() : super([]);

  void set(List<UserData> friends) => state = friends;

  Future<void> clear() async => state = [];

  void removeById(String id) {
    state = state.where((user) => user.id != id).toList();
  }

  void addUsers(UserData newFriend) {
    // 중복 방지 및 정렬 후 추가
    if (!state.any((f) => f.id == newFriend.id)) {
      state = [...state, newFriend]..sort((a, b) => a.name.compareTo(b.name));
    }
  }

  List<UserData> get list => state;
}

final roomMemberListProvider =
    StateNotifierProvider<UserListNotifier, List<UserData>>(
  (ref) => UserListNotifier(),
);

final friendListProvider =
    StateNotifierProvider<UserListNotifier, List<UserData>>(
  (ref) => UserListNotifier(),
);
