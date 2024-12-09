import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:machat/features/common/interfaces/repository_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final registerRepositoryProvider = Provider<RepositoryService>((ref) {
  return RegisterRepository();
});

class RegisterRepository implements RepositoryService {
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
      // 나중에 다이얼로그 띄우도록 변경
      print(e);
      return {'success': false};
    }
  }

  @override
  Future<Map<String, dynamic>> read(String id) async =>
      throw UnimplementedError();

  @override
  Future<List<Map<String, dynamic>>> readAll({String? searchId}) async =>
      throw UnimplementedError();

  @override
  Future<Map<String, dynamic>> update(
          String id, Map<String, dynamic> data) async =>
      throw UnimplementedError();

  @override
  Future<void> delete(String id) async => throw UnimplementedError();
}
