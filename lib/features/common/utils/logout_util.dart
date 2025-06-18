import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/common/providers/user_cache_providers.dart';

Future<void> logout(Ref ref) async {
  await ref.read(userCacheProvider.notifier).clearCache();
  await ref.read(friendListProvider.notifier).clear();
}
