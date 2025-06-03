part of './lib.dart';

// 마챗 기본 레이아웃
class DefaultLayout extends StatelessWidget {
  final Widget child;
  // floatingActionButton 외부 주입
  final Widget? floatingActionButton;
  // 로그인이 필요한 작업인지
  final bool? needLogin;
  final String? title;
  final List<Widget>? adaptors;
  final List<Widget>? actions;
  final Widget? drawer;
  final Widget? endDrawer;

  const DefaultLayout({
    super.key,
    required this.child,
    this.floatingActionButton,
    this.needLogin,
    this.title,
    this.adaptors = const [],
    this.actions = const [],
    this.drawer,
    this.endDrawer,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    // 모바일일 때 분기
    Widget responseWidget = screenWidth <= 760
        ? MobileScaffold(
            floatingActionButton: floatingActionButton,
            title: title,
            actions: [...actions ?? []],
            drawer: drawer,
            endDrawer: endDrawer,
            child: child,
          )
        : WebScaffold(
            floatingActionButton: floatingActionButton,
            title: title,
            actions: [...actions ?? []],
            drawer: drawer,
            endDrawer: endDrawer,
            child: child,
          );

    // 여러 레이아웃 어댑터를 child에 적용
    Widget thisChild = Stack(children: [...adaptors ?? [], responseWidget]);

    // SnackBarManagerConnector로 감싸서 레이아웃 아래에서 스낵바 표현
    // UserChecker로 감싸서 로그인 확인 로직 추가
    return SnackBarManagerConnector(
      child: UserChecker(
        needLogin: needLogin,
        child: thisChild,
      ),
    );
  }
}
