import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../router/lib.dart';

class TokenSplash extends ConsumerWidget {
  const TokenSplash({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final route = ref.read(goRouterProvider);

    //TODO 로그인 토큰 여부로 화면 분기처리

    Future.delayed(const Duration(seconds: 2)).then((_) {
      route.goNamed(TokenRouterPath.login.name);
      // MaterialPageRoute(builder: ((context) => LoginPage()));
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Image.asset(
          'lib/assets/images/ma_chat.png',
          height: 500,
          width: 500,
        ),
      ),
    );
  }
}
