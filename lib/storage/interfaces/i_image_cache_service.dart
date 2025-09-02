import 'dart:typed_data';

abstract class IImageCacheService {
  Future<void> save(String key, Uint8List bytes);
  Future<Uint8List?> load(String key);
  Future<void> delete(String key);
}
