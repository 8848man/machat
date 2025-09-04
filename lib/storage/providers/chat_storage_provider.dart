import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/core/models/chat.dart';
import 'package:machat/storage/interfaces/i_json_storage.dart';
import 'package:machat/storage/local/json_storage_mobile.dart';
import 'package:machat/storage/local/json_storage_web.dart';

final chatStorageProvider = Provider<JsonStorageInterface<List<Chat>>>((ref) {
  if (kIsWeb) {
    return JsonStorageWeb<List<Chat>>(
      fromJson: (json) {
        final list = json as List<dynamic>;
        return list
            .map((e) => Chat.fromJson(e as Map<String, dynamic>))
            .toList();
      },
      toJson: (chats) => chats.map((c) => c.toJson()).toList(),
    );
  } else {
    return JsonStorageMobile<List<Chat>>(
      fromJson: (json) {
        final list = json as List<dynamic>;
        return list
            .map((e) => Chat.fromJson(e as Map<String, dynamic>))
            .toList();
      },
      toJson: (chats) => chats.map((c) => c.toJson()).toList(),
    );
  }
});
