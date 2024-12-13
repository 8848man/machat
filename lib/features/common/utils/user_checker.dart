import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/router/lib.dart';
import 'package:toastification/toastification.dart';

class UserChecker extends ConsumerWidget {
  final Widget child;
  final bool? needLogin;

  const UserChecker({
    super.key,
    required this.child,
    this.needLogin = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final User? user = FirebaseAuth.instance.currentUser;

    // 로그인 상태가 필요한 경우에만 체크
    if (needLogin == true && user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        toastification.show(
          context: context, // optional if you use ToastificationWrapper
          title: const Text('로그인을 하고 이용해주세요!'),
          autoCloseDuration: const Duration(seconds: 2),
        );
      });

      ref.read(goRouterProvider).goNamed(RouterPath.login.name);
      return const SizedBox.shrink(); // 빈 위젯 반환
    }

    return child; // 하위 위젯 렌더링
  }
}
