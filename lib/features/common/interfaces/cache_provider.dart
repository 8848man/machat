abstract class CacheProvider<T> {
  Future<void> save(String key, T value);
  Future<T?> read(String key);
  Future<void> delete(String key);
  Future<void> clear();
  Future<void> deleteAll();
}
