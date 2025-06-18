import 'package:flutter/material.dart';
import 'package:machat/features/common/providers/loading_state_provider.dart';
import 'package:machat/features/register/lib.dart';
import 'package:machat/features/register/models/register_model.dart';
import 'package:machat/features/register/repository/register_repository.dart';
import 'package:machat/router/lib.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'register_view_model.g.dart';

@riverpod
class RegisterViewModel extends _$RegisterViewModel {
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  @override
  RegisterModel build() {
    return initData();
  }

  RegisterModel initData() {
    return const RegisterModel();
  }

  /// UI
  // 이메일 변경시 검증
  void emailChangeValidate() {
    final String? errorText = emailChangeValidation(emailController.text);
    state = state.copyWith(emailErrorText: errorText);
  }

  // 이메일 종합 검증
  bool emailValidate() {
    String? errorText = emailValidation(emailController.text);
    // 검증 에러메세지가 null이 아닐 경우, 에러텍스트 변경 후 false토큰 반환
    if (errorText != null) {
      state = state.copyWith(emailErrorText: errorText);
      return false;
    }

    // 검증 메세지가 null일 경우, 검증 완료
    return true;
  }

  // 이름 변경시 검증
  void nameChangeValidate() {
    final String? errorText = nameChangeValidation(nameController.text);
    state = state.copyWith(nameErrorText: errorText);
  }

  // 이름 종합 검증
  bool nameValidate() {
    final String? errorText = nameValidation(nameController.text);
    if (errorText != null) {
      state = state.copyWith(nameErrorText: errorText);
      return false;
    }

    // 검증 메세지가 null일 경우, 검증 완료
    return true;
  }

  // 비밀번호 종합 검증
  bool pwdValidate() {
    final String? errorText = passwordValidation(pwdController.text);
    if (errorText != null) {
      state = state.copyWith(pwdErrorText: errorText);
      return false;
    }

    // 검증 메세지가 null일 경우, 검증 완료
    return true;
  }

  // 유저 등록
  Future<void> registUser() async {
    // 로딩 상태 true로 변경
    ref.read(loadingStateProvider.notifier).update((state) => true);
    // 이메일, 이름, 비밀번호 검증
    if (!emailValidate()) return;
    if (!nameValidate()) return;
    if (!pwdValidate()) return;

    final bool isSuccess = await signUp(
      emailController.text,
      pwdController.text,
      nameController.text,
    );

    if (isSuccess) {
      final router = ref.read(goRouterProvider);
      router.goNamed(RouterPath.login.name);
    }

    
    // 로딩 상태 true로 변경
    ref.read(loadingStateProvider.notifier).update((state) => false);
  }

  void goLogin() {
    final router = ref.read(goRouterProvider);
    router.goNamed(RouterPath.login.name);
  }

  /// UI/

  /// network
  Future<bool> signUp(String email, String password, String name) async {
    final repository = ref.read(registerRepositoryProvider);
    final Map<String, dynamic> response = await repository.create({
      'email': email,
      'password': password,
      'name': name,
    });
    // 정상 요청 완료시 true 토큰
    if (response['success'] == true) return true;

    return false;
  }

  /// network/
}
