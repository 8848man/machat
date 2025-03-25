import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:machat/router/lib.dart';

Widget buildConversation() {
  return Column(
    children: [
      IconButton(
        icon: const Icon(
          IconData(0xe153, fontFamily: 'MaterialIcons'),
          size: 25,
        ),
        tooltip: '대화하기',
        onPressed: () {
          print('test001, 대화하기 opened');
        },
      ),
      const Text('대화하기'),
    ],
  );
}

Widget buildAuthButton(User? user, GoRouter router) {
  return user == null ? buildLogin(router) : buildLogout(router);
}

Widget buildLogin(GoRouter router) {
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

Widget buildLogout(GoRouter router) {
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
        onPressed: () async {
          // 로그아웃 버튼
          await FirebaseAuth.instance.signOut();
          router.goNamed(RouterPath.login.name);
        },
      ),
      const Text('로그아웃'),
    ],
  );
}
