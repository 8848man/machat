import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/networks/firestore_provider.dart';

import '../models/token_user_data.dart';

final tokenProfileRepositoryProvider = Provider<TokenProfileRepository>((ref) {
  return TokenProfileRepository(ref);
});

class TokenProfileRepository {
  final Ref ref;
  TokenProfileRepository(this.ref);

  // 프로필 정보를 가져오는 메서드
  Future<TokenUserData> getProfile(String userId) async {
    try {
      final userDoc = await ref
          .read(firestoreProvider)
          .collection('users')
          .doc(userId)
          .get();

      return TokenUserData.fromJson(userDoc.data() ?? {});
    } catch (e) {
      print('Failed to fetch profile: $e');
      throw Exception('Failed to fetch profile');
    }
  }
}
