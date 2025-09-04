abstract class JsonStorageInterface<T> {
  Future<void> init();

  Future<void> save(String key, T value);

  Future<T?> load(String key);

  Future<void> delete(String key);

  Future<List<String>> getAllKeys();
}
