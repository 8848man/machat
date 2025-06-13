part of './lib.dart';

List<Widget> getActions(User? user, WidgetRef ref) {
  final UserViewModel notifier = ref.read(userViewModelProvider.notifier);
  final GoRouter router = ref.read(goRouterProvider);
  return <Widget>[
    // login 페이지 버튼
    if (user == null)
      IconButton(
        icon: Image.asset(
          'lib/assets/icons/login.png',
          scale: 20,
        ),
        onPressed: () => router.goNamed(RouterPath.login.name),
      ),
    // 로그아웃 버튼
    if (user != null)
      IconButton(
        icon: Center(
          child: Image.asset(
            'lib/assets/icons/logout.png',
            scale: 20,
          ),
        ),
        onPressed: () async => await notifier.signOutProcess(),
      ),
  ];
}
