// // CacheRepository.dart
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:machat/features/repository_util/cache_util.dart';

// abstract class CacheRepository<T> {
//   Future<void> cacheRegist(
//     String key,
//     T value,
//     Duration disposeTime,
//     Ref ref, // 명확한 타입 사용
//   ) async {
//     final cacheService = ref.read(cacheUtilProvider);

//     cacheService.register<T>(
//       key: key,
//       create: (ref) => value,
//       disposeAfter: disposeTime,
//     );
//   }

//   Future<void> cacheDispose(String key, Ref ref) async {
//     final cacheService = ref.read(cacheUtilProvider);
//     cacheService.remove(key);
//   }

//   Future<T?> getCacheData(String key, Ref ref) async {
//     final cacheService = ref.read(cacheUtilProvider);
//     final cachedProvider = cacheService.getProvider<T>(key);

//     return cachedProvider != null ? ref.read(cachedProvider) : null;
//   }
// }
