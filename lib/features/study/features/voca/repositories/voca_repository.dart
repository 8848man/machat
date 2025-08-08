import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/config/url_config.dart';
import 'package:machat/features/common/providers/loading_state_provider.dart';
import 'package:machat/features/snack_bar_manager/lib.dart';
import 'package:machat/features/study/features/voca/models/word_model.dart';
import 'package:machat/networks/firestore_provider.dart';

final vocaRepositoryProvider = Provider<VocaRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  return VocaRepository(ref: ref, firestore: firestore);
});

class VocaRepository {
  Ref ref;
  FirebaseFirestore firestore;
  VocaRepository({
    required this.ref,
    required this.firestore,
  });

  Future<WordModel?> getWord(String wordText) async {
    try {
      ref.read(loadingStateProvider.notifier).update((state) => true);
      final uri = Uri.parse('$GEMINI_API_DICTIONARY_URL$wordText');
      final token = await FirebaseAuth.instance.currentUser!.getIdToken();

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // UTF8로 명시적 디코딩
        final decodedString = utf8.decode(response.bodyBytes);

        final Map<String, dynamic> jsonResp = json.decode(decodedString);
        final data = jsonResp['data'];
        if (data != null) {
          return WordModel.fromJson({
            ...data,
            'id': wordText,
          });
        }
      }

      // 서버 응답이 실패거나 data가 없으면 null 반환
      return null;
    } catch (e) {
      SnackBarCaller().callSnackBar(ref, '해당 단어는 사전에 없는거같아요!');
      print('getWord error occured! $e');

      rethrow;
    } finally {
      ref.read(loadingStateProvider.notifier).update((state) => false);
    }
  }

  Future<void> saveWordToMasterVoca(WordModel word) async {
    final wordRef = firestore.collection('master_voca').doc(word.id);
    await wordRef.set(word.toJson());
  }

  Future<void> saveWordToVocabulary({
    required String vocabId,
    required WordModel word,
  }) async {
    final vocabWordRef = firestore
        .collection('vocabulary')
        .doc(vocabId)
        .collection('wordList')
        .doc(word.id);
    await vocabWordRef.set(word.toJson());
  }

  Future<List<WordModel>> getWordList({
    required String userId,
    required String vocabId,
  }) async {
    try {
      final querySnapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('user_vocabulary')
          .doc(vocabId)
          .collection('wordList')
          .get();

      // 각 문서를 WordModel로 변환 후 리스트로 반환
      return querySnapshot.docs
          .map((doc) => WordModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('getWordList error! $e');
      rethrow;
    }
  }
}
