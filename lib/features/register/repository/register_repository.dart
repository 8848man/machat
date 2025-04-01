import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/common/interfaces/repository_service.dart';
import 'package:machat/features/snack_bar_manager/lib.dart';

final registerRepositoryProvider = Provider<RepositoryService>((ref) {
  return RegisterRepository(ref: ref);
});

class RegisterRepository implements RepositoryService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Ref ref;

  RegisterRepository({required this.ref});

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
    } on FirebaseAuthException catch (e) {
      // 이메일이 이미 사용 중인 경우 처리
      if (e.code == 'email-already-in-use') {
        SnackBarCaller().callSnackBar(ref, '중복된 이메일입니다.');
      }
      // 다른 예외 처리
      return {'success': false};
    } catch (e) {
      SnackBarCaller().callSnackBar(ref, '알 수 없는 에러가 발생했습니다. 다시 시도해주세요.');
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
  Future<void> delete(String id, {String? userId}) async =>
      throw UnimplementedError();
}
