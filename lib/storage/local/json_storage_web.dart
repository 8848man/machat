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

  // DB 초기화
  @override
  Future<void> init() async {
    if (_db != null) return;

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
  }

  // JSON 저장
  @override
  Future<void> save(String key, T value) async {
    await init();
    final txn = _db!.transaction(_storeName, 'readwrite');
    final store = txn.objectStore(_storeName);
    await store.put(jsonEncode(toJson(value)), key); // jsonEncode 추가
    await txn.completed;
  }

  @override
  Future<T?> load(String key) async {
    await init();
    final txn = _db!.transaction(_storeName, 'readonly');
    final store = txn.objectStore(_storeName);
    final jsonString = await store.getObject(key) as String?;
    await txn.completed;
    if (jsonString == null) return null;

    final decoded = jsonDecode(jsonString); // decode
    return fromJson(decoded);
  }

  // JSON 삭제
  @override
  Future<void> delete(String key) async {
    await init();
    final txn = _db!.transaction(_storeName, 'readwrite');
    final store = txn.objectStore(_storeName);
    await store.delete(key);
    await txn.completed;
  }

  // 모든 키 가져오기 (선택)
  @override
  Future<List<String>> getAllKeys() async {
    await init();
    final txn = _db!.transaction(_storeName, 'readonly');
    final store = txn.objectStore(_storeName);
    final keys = await store.getAllKeys();
    await txn.completed;
    return keys.cast<String>();
  }
}
