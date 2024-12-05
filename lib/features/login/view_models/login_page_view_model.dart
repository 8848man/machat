import 'package:flutter/material.dart';
import 'package:machat/router/lib.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_page_view_model.g.dart';

@riverpod
class LoginPageViewModel extends _$LoginPageViewModel {
  TextEditingController idController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  @override
  Future<void> build() async {
    // final LessonAreaData areaData = await getLessonAreaList();

    // return areaData;
  }

  void login() {
    print('test001');
    final router = ref.read(goRouterProvider);
    router.goNamed(RouterPath.home.name);
  }

  void goRegister() {
    final router = ref.read(goRouterProvider);
    router.goNamed(RouterPath.register.name);
  }
}
