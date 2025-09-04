import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/storage/interfaces/i_json_storage.dart';
import 'package:machat/storage/local/json_storage_mobile.dart';
import 'package:machat/storage/local/json_storage_web.dart';
import 'package:machat/storage/models/storage_chat.dart';

final chatStorageProvider =
    Provider<JsonStorageInterface<List<StorageChat>>>((ref) {
  if (kIsWeb) {
    return JsonStorageWeb<List<StorageChat>>(
      fromJson: (json) {
        final list = json as List<dynamic>;
        return list
            .map((e) => StorageChat.fromJson(e as Map<String, dynamic>))
            .toList();
      },
      toJson: (chats) => chats.map((c) => c.toJson()).toList(),
    );
  } else {
    return JsonStorageMobile<List<StorageChat>>(
      fromJson: (json) {
        final list = json as List<dynamic>;
        return list
            .map((e) => StorageChat.fromJson(e as Map<String, dynamic>))
            .toList();
      },
      toJson: (chats) => chats.map((c) => c.toJson()).toList(),
    );
  }
});
