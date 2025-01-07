import 'package:machat/features/cache/view_models/profile_cache.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cache_view_model.g.dart';

// cacheViewModelProvider 참조자
@riverpod
class CacheViewModel extends _$CacheViewModel {
  @override
  Future<void> build() async {
    ref.read(profileCacheProvider);
  }
}
