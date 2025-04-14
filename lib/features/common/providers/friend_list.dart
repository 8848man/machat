import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/common/models/user_data.dart';

// StateProvider<List<UserData>> friendListProvider = StateProvider((ref) => []);

class FriendListNotifier extends StateNotifier<List<UserData>> {
  FriendListNotifier() : super([]);

  void set(List<UserData> friends) => state = friends;

  void clear() => state = [];

  void removeById(String id) {
    state = state.where((user) => user.id != id).toList();
  }

  void addFriend(UserData newFriend) {
    // 중복 방지 및 정렬 후 추가
    if (!state.any((f) => f.id == newFriend.id)) {
      state = [...state, newFriend]..sort((a, b) => a.name.compareTo(b.name));
    }
  }

  List<UserData> get list => state;
}

final friendListProvider =
    StateNotifierProvider<FriendListNotifier, List<UserData>>(
  (ref) => FriendListNotifier(),
);
