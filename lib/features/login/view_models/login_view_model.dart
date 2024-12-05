import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:machat/features/login/models/login_model.dart';
import 'package:machat/features/login/repository/login_repository.dart';
import 'package:machat/router/lib.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_view_model.g.dart';

@riverpod
class LoginViewModel extends _$LoginViewModel {
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  @override
  LoginModel build() {
    return initData();
  }

  LoginModel initData() {
    return const LoginModel();
  }

  Future<void> login() async {
    final repository = ref.read(loginRepositoryProvider);

    // 로그인 로직 실행
    final isLogined =
        await repository.login(emailController.text, pwdController.text);

    // 로그인 성공 로직
    if (isLogined) {
      // FirebaseAuth에서 현재 사용자 가져오기
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("User is not authenticated.");
      }

      // 유저 프로필 가져오기
      final userProfile = await repository.getUserProfile(user.uid);

      // 필요한 로직 처리 (예: 상태 업데이트, UI 반영 등)
      print('User Profile: $userProfile');

      // 페이지 이동
      final router = ref.read(goRouterProvider);
      router.goNamed(RouterPath.home.name);
    } else {
      state = state.copyWith(
          emailErrorText: '이메일 확인', pwdErrorText: '이메일 혹은 비밀번호를 다시 한번 확인해주세요.');
    }
  }

  void goRegister() {
    final router = ref.read(goRouterProvider);
    router.goNamed(RouterPath.register.name);
  }
}
