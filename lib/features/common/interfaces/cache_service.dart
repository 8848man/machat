abstract class CacheService {
  Future<void> save(String key, String value);
  // Future<void> saveJson(String key, Json value);
  Future<String?> read(String key);
  Future<void> delete(String key);
  Future<void> clear();
}
