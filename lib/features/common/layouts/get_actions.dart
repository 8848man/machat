part of './lib.dart';

List<Widget> getActions(User? user, WidgetRef ref) {
  final router = ref.read(goRouterProvider);
  return <Widget>[
    // login 페이지 버튼
    if (user == null)
      IconButton(
        icon: Image.asset(
          'icons/login.png',
          scale: 20,
        ),
        onPressed: () => router.goNamed(RouterPath.login.name),
      ),
    // 로그아웃 버튼
    if (user != null)
      IconButton(
        icon: Center(
          child: Image.asset(
            'icons/logout.png',
            scale: 20,
          ),
        ),
        onPressed: () async {
          // 로그아웃 버튼
          await FirebaseAuth.instance.signOut();
          router.goNamed(RouterPath.login.name);
        },
      ),
  ];
}
