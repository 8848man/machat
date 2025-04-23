import 'package:flutter_riverpod/flutter_riverpod.dart';

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
