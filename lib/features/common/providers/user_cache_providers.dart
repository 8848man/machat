import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/core/providers/user_cache_provider.dart';

StateProvider userCacheProvider =
    StateProvider<Map<String, UserCacheProvider>>((ref) {
  return {};
});
