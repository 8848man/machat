import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserCacheNotifier extends StateNotifier<Map<String, dynamic>> {
  UserCacheNotifier() : super({});

  void addCache(String key, dynamic value) {
    state = {...state, key: value};
  }

  void clearCache() {
    state = {};
  }
}

final userCacheProvider =
    StateNotifierProvider<UserCacheNotifier, Map<String, dynamic>>(
  (ref) => UserCacheNotifier(),
);

void logout(WidgetRef ref) {
  ref.read(userCacheProvider.notifier).clearCache();
}
