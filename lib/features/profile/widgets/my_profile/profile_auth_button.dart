import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/common/view_models/user_view_model.dart';
import 'package:machat/router/lib.dart';

Widget buildAuthButton(User? user, WidgetRef ref) {
  return user == null ? buildLogin(ref) : buildLogout(ref);
}

Widget buildLogin(WidgetRef ref) {
  final router = ref.read(goRouterProvider);
  return Column(
    children: [
      IconButton(
        icon: Image.asset(
          'lib/assets/icons/login.png',
          scale: 20,
        ),
        tooltip: '로그인',
        onPressed: () => router.goNamed(RouterPath.login.name),
      ),
      const Text('로그인'),
    ],
  );
}

Widget buildLogout(WidgetRef ref) {
  final notiifer = ref.read(userViewModelProvider.notifier);
  return Column(
    children: [
      IconButton(
        icon: Center(
          child: Image.asset(
            'lib/assets/icons/logout.png',
            scale: 20,
          ),
        ),
        tooltip: '로그아웃',
        onPressed: () async => await notiifer.signOutProcess(),
      ),
      const Text('로그아웃'),
    ],
  );
}
