import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:machat/repository_service/repository_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final dataRepositoryProvider = Provider<RepositoryService>((ref) {
  return FirebaseUserRepository();
});

class FirebaseUserRepository implements RepositoryService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 회원가입
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> data) async {
    try {
      // Firebase Authentication에 이메일/비밀번호로 유저 생성
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: data['email'],
        password: data['password'],
      );

      // Firestore에 유저 데이터 저장
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'id': userCredential.user!.uid,
        'email': data['email'],
        'name': data['name'],
        'nationId': data['nationId'],
        'profileUrl': data['profileUrl'],
      });

      return {'success': true};
    } catch (e) {
      print(e);
      return {'success': false};
    }
  }

  // 로그인 회원 불러오기
  @override
  Future<Map<String, dynamic>> read(String id) async {
    try {
      final doc = await _firestore.collection('users').doc(id).get();
      if (!doc.exists) throw Exception('User not found');
      return doc.data()!;
    } catch (e) {
      throw Exception('Failed to read user: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> readAll() async {
    try {
      final querySnapshot = await _firestore.collection('users').get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Failed to read all users: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> update(
      String id, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(id).update(data);
      return {'success': true};
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _firestore.collection('users').doc(id).delete();
      await _auth.currentUser!.delete();
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }
}
