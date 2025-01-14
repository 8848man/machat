import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/snack_bar_manager/lib.dart';
import 'package:machat/router/lib.dart';

// 라우팅 함수
// 라우팅 후 스낵바 띄워줘야 할 경우 message에 string값 넣어주기
class Router {
  void goNamed(Ref ref, RouterPath path, String? message) {
    ref.read(goRouterProvider).goNamed(path.name);
    if (message == null) {
      return;
    }
    Future.delayed(const Duration(seconds: 1), () {
      showSnackBar(ref, message);
    });
  }
}
