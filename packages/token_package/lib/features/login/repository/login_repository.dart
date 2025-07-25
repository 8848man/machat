import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final loginRepositoryProvider = Provider<LoginRepository>((ref) {
  return LoginRepository();
});

class LoginRepository {
  LoginRepository();
  // Login 메서드 추가
  Future<bool> login(String username, String password) async {
    try {
      final auth = FirebaseAuth.instance;
      await auth.signInWithEmailAndPassword(
          email: username, password: password);
      return true;
    } catch (e) {
      print('exception occured $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      // Firestore 컬렉션에서 유저 문서를 가져오기
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      // 문서가 존재하지 않는 경우 처리
      if (!doc.exists) {
        throw Exception('User not found');
      }

      // 데이터를 반환 (doc.data()는 Map<String, dynamic>? 타입이므로 null 방지)
      return doc.data()!;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }
}
