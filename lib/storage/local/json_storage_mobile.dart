import 'dart:convert';

import 'package:hive_flutter/adapters.dart';
import 'package:machat/storage/interfaces/i_json_storage.dart';

class JsonStorageMobile<T> implements JsonStorageInterface<T> {
  final T Function(Object? json) fromJson;
  final Object Function(T value) toJson;

  JsonStorageMobile({
    required this.fromJson,
    required this.toJson,
  });

  static const _boxName = 'app_json_storage';
  Box<String>? _box;

  @override
  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.initFlutter();
      _box = await Hive.openBox<String>(_boxName);
    } else {
      _box = Hive.box<String>(_boxName);
    }
  }

  @override
  Future<void> save(String key, T value) async {
    await init();
    final jsonString = jsonEncode(toJson(value));
    await _box!.put(key, jsonString);
  }

  @override
  Future<T?> load(String key) async {
    await init();
    final jsonString = _box!.get(key);
    if (jsonString == null) return null;
    final decoded = jsonDecode(jsonString);
    return fromJson(decoded);
  }

  @override
  Future<void> delete(String key) async {
    await init();
    await _box!.delete(key);
  }

  @override
  Future<List<String>> getAllKeys() async {
    await init();
    return _box!.keys.cast<String>().toList();
  }
}
