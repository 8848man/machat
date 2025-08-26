import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/ai/models/ai_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final aiRepositoryProvider = Provider<AiRepository>((ref) {
  return AiRepository(ref);
});

class AiRepository {
  final Ref ref;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AiRepository(this.ref);

  Future<Map<String, dynamic>?> createCharacter(AiModel data) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final AiModel updatedData = data.copyWith(
          createdAt: DateTime.now(), createdBy: auth.currentUser?.uid ?? '');
      final chatRef = _firestore.collection('ai_models').doc(data.name);
      await chatRef.set(updatedData.toJson());
      return {};
    } catch (e) {
      throw Exception('cannot created character');
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
}
