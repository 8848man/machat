import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:machat/features/token/features/commons/models/token_user_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final tokenProfileRepositoryProvider = Provider<TokenProfileRepository>((ref) {
  return TokenProfileRepository();
});

class TokenProfileRepository {
  TokenProfileRepository();

  // 프로필 정보를 가져오는 메서드
  Future<TokenUserData> getProfile(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      print('User profile fetched: ${userDoc.data()}');

      return TokenUserData.fromJson(userDoc.data() ?? {});
    } catch (e) {
      print('Failed to fetch profile: $e');
      throw Exception('Failed to fetch profile');
    }
  }
}
