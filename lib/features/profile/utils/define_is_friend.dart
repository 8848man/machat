import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/common/models/user_data.dart';
import 'package:machat/features/common/providers/user_cache_providers.dart';

bool defineIsFriend(WidgetRef ref, String uid) {
  final List<UserData> friendList = ref.watch(friendListProvider);

  return friendList.any((friend) => friend.id == uid);
}
