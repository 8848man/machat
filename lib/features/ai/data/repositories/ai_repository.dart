import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/config/url_config.dart';
import 'package:machat/features/common/models/ai/ai_chat_request.dart';
import 'package:machat/features/common/models/ai/ai_chat_response.dart';
import 'package:machat/features/common/models/ai/ai_model.dart';
import 'package:machat_token_service/features/commons/providers/loading_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;

final aiRepositoryProvider = Provider<AiRepository>((ref) {
  return AiRepository(ref);
});

class AiRepository {
  final Ref ref;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AiRepository(this.ref);

  // Future<Map<String, dynamic>?> createCharacter(AiModel data) async {
  //   try {
  //     final FirebaseAuth auth = FirebaseAuth.instance;
  //     final AiModel updatedData = data.copyWith(
  //         createdAt: DateTime.now(), createdBy: auth.currentUser?.uid ?? '');
  //     final chatRef = _firestore.collection('ai_models').doc(data.name);
  //     await chatRef.set(updatedData.toJson());
  //     return {};
  //   } catch (e) {
  //     throw Exception('cannot created character');
  //   }
  // }

  Future<Map<String, dynamic>?> createCharacter(AiModel data) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      final String uid = auth.currentUser?.uid ?? '';
      if (uid.isEmpty) throw Exception("User not authenticated");

      final AiModel updatedData = data.copyWith(
        createdAt: DateTime.now(),
        createdBy: uid,
      );

      final DocumentReference aiModelRef =
          firestore.collection('ai_models').doc(data.name);
      final DocumentReference userRef =
          firestore.collection('users').doc(data.name);

      await firestore.runTransaction((transaction) async {
        // ai_models 문서 추가
        transaction.set(aiModelRef, updatedData.toJson());

        // users 문서 추가
        transaction.set(userRef, {
          "email": "AiModel-NoEmail",
          "id": data.name,
          "name": data.name,
          "nationId": null,
          "profileUrl": null,
        });
      });

      return {};
    } catch (e, st) {
      print("Transaction failed: $e\n$st");
      throw Exception('cannot create character');
    }
  }

  Future<AiModel> getCharacter(String name) async {
    try {
      final doc = await _firestore.collection('ai_models').doc(name).get();

      if (!doc.exists) {
        throw Exception('AI model not found');
      }

      return AiModel.fromJson(doc.data()!);
    } catch (e) {
      throw Exception('AI model not found');
    }
  }

  Future<AiModelPage> getAllCharacter({
    required int limit,
    String? orderBy,
    DocumentSnapshot? startAfterDoc,
  }) async {
    try {
      Query query = _firestore
          .collection('ai_models')
          .orderBy(orderBy ?? 'name')
          .limit(limit);

      // startAfter 지원
      if (startAfterDoc != null) {
        query = query.startAfterDocument(startAfterDoc);
      }
      final querySnapshot = await query.get();

      final models = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return AiModel.fromJson(data);
      }).toList();

      // 마지막 문서 저장 (다음 페이지 요청 시 필요)
      final lastDoc =
          querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;

      return AiModelPage(models: models, lastDoc: lastDoc);
    } catch (e) {
      throw Exception('Failed to fetch AI models: $e');
    }
  }

  Future<void> deleteCharacter(String name) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      final DocumentReference aiModelRef =
          firestore.collection('ai_models').doc(name);
      final DocumentReference userRef = firestore.collection('users').doc(name);

      await firestore.runTransaction((transaction) async {
        // ai_models 문서 삭제
        transaction.delete(aiModelRef);

        // users 문서 삭제
        transaction.delete(userRef);
      });

      print("Character and related user successfully deleted");
    } catch (e, st) {
      print("Transaction failed: $e\n$st");
      throw Exception('cannot delete character');
    }
  }

  Future<AiChatResponseModel?> getChatResponse(AiChatRequest request) async {
    try {
      ref.read(loadingStateProvider.notifier).update((state) => true);

      final uri = Uri.parse(GEMINI_API_CHAT_URL);
      final token = await FirebaseAuth.instance.currentUser!.getIdToken();

      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      final body = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(body);

      if (response.statusCode == 200) {
        return AiChatResponseModel.fromJson(jsonData['data']);
      } else {
        throw Exception('API 호출 실패: ${response.statusCode} $body');
      }
    } catch (e, st) {
      print('createChatResponse error: $e\n$st');
      return null;
    } finally {
      ref.read(loadingStateProvider.notifier).update((state) => false);
    }
  }
}
