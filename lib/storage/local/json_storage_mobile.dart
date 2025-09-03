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

  static const _boxName = 'machat_chat_storage';
  Box<String>? _box;

  @override
  Future<void> init() async {
    try {
      if (!Hive.isBoxOpen(_boxName)) {
        await Hive.initFlutter();
        _box = await Hive.openBox<String>(_boxName);
      } else {
        _box = Hive.box<String>(_boxName);
      }
    } catch (e) {
      print('Hive init failed: $e');
      // 필요하면 rethrow하거나 그냥 무시
    }
  }

  @override
  Future<void> save(String key, T value) async {
    try {
      await init();
      final jsonString = jsonEncode(toJson(value));
      await _box!.put(key, jsonString);
    } catch (e) {
      print('Failed to save key "$key": $e');
    }
  }

  @override
  Future<T?> load(String key) async {
    try {
      await init();
      final jsonString = _box!.get(key);
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
      await _box!.delete(key);
    } catch (e) {
      print('Failed to delete key "$key": $e');
    }
  }

  @override
  Future<List<String>> getAllKeys() async {
    try {
      await init();
      return _box!.keys.cast<String>().toList();
    } catch (e) {
      print('Failed to get all keys: $e');
      return [];
    }
  }
}
