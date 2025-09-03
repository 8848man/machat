import 'dart:convert';

import 'package:idb_shim/idb_browser.dart';
import 'package:machat/storage/interfaces/i_json_storage.dart';

class JsonStorageWeb<T> implements JsonStorageInterface<T> {
  final T Function(Object? json) fromJson;
  final Object Function(T value) toJson;

  JsonStorageWeb({
    required this.fromJson,
    required this.toJson,
  });

  static const _dbName = 'app_json_storage';
  static const _storeName = 'json_store';
  Database? _db;

  @override
  Future<void> init() async {
    if (_db != null) return;

    try {
      _db = await idbFactoryBrowser.open(
        _dbName,
        version: 1,
        onUpgradeNeeded: (VersionChangeEvent e) {
          final db = (e.target as Request).result;
          if (!db.objectStoreNames.contains(_storeName)) {
            db.createObjectStore(_storeName, autoIncrement: false);
          }
        },
      );
    } catch (e) {
      print('Failed to initialize IndexedDB: $e');
    }
  }

  @override
  Future<void> save(String key, T value) async {
    try {
      await init();
      if (_db == null) return;

      final txn = _db!.transaction(_storeName, 'readwrite');
      final store = txn.objectStore(_storeName);
      await store.put(jsonEncode(toJson(value)), key);
      await txn.completed;
    } catch (e) {
      print('Failed to save key "$key": $e');
    }
  }

  @override
  Future<T?> load(String key) async {
    try {
      await init();
      if (_db == null) return null;

      final txn = _db!.transaction(_storeName, 'readonly');
      final store = txn.objectStore(_storeName);
      final jsonString = await store.getObject(key) as String?;
      await txn.completed;

      if (jsonString == null) return null;
      final decoded = jsonDecode(jsonString);
      return fromJson(decoded);
    } catch (e) {
      print('Failed to load key "$key": $e');
      return null;
    }
  }

  @override
  Future<void> delete(String key) async {
    try {
      await init();
      if (_db == null) return;

      final txn = _db!.transaction(_storeName, 'readwrite');
      final store = txn.objectStore(_storeName);
      await store.delete(key);
      await txn.completed;
    } catch (e) {
      print('Failed to delete key "$key": $e');
    }
  }

  @override
  Future<List<String>> getAllKeys() async {
    try {
      await init();
      if (_db == null) return [];

      final txn = _db!.transaction(_storeName, 'readonly');
      final store = txn.objectStore(_storeName);
      final keys = await store.getAllKeys();
      await txn.completed;
      return keys.cast<String>();
    } catch (e) {
      print('Failed to get all keys: $e');
      return [];
    }
  }
}
