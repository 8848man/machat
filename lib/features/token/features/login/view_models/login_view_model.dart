import 'package:flutter/material.dart';
import 'package:machat/features/token/features/commons/providers/loading_state_provider.dart';
import 'package:machat/features/token/features/commons/snack_bar_manager/lib.dart';
import 'package:machat/features/token/features/login/models/login_model.dart';
import 'package:machat/features/token/features/login/repository/login_repository.dart';
import 'package:machat/features/token/router/lib.dart';
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
    try {
      // 로딩 상태 true로 변경
      ref.read(loadingStateProvider.notifier).update((state) => true);
      final repository = ref.read(loginRepositoryProvider);

      // 로그인 로직 실행
      final isLogined =
          await repository.login(emailController.text, pwdController.text);

      // 로그인 성공 로직
      if (isLogined) {
        // 페이지 이동
        final router = ref.read(goRouterProvider);
        router.replaceNamed(TokenRouterPath.token.name);
      } else {
        state = state.copyWith(
            emailErrorText: '이메일 확인',
            pwdErrorText: '이메일 혹은 비밀번호를 다시 한번 확인해주세요.');
      }
    } catch (e) {
      SnackBarCaller()
          .callSnackBar(ref, '알 수 없는 이유로 로그인에 실패했습니다. 개발자에게 문의해주세요.');
    } finally {
      // 로딩 상태 flase로 변경
      ref.read(loadingStateProvider.notifier).update((state) => false);
    }
  }

  // void goRegister() {
  //   final router = ref.read(goRouterProvider);
  //   router.goNamed(TokenRouterPath.register.name);
  // }
}
