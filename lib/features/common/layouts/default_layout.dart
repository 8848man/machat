part of './lib.dart';

// 마챗 기본 레이아웃
class DefaultLayout extends StatelessWidget {
  final Widget child;
  final Widget? floatingActionButton;

  const DefaultLayout(
      {super.key, required this.child, this.floatingActionButton});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    // 모바일일 때 분기
    switch (screenWidth) {
      case <= 760:
        return MobileScaffold(
          floatingActionButton: floatingActionButton,
          child: child,
        );
      case <= 1240:
        return WebScaffold(
          floatingActionButton: floatingActionButton,
          child: child,
        );
      default:
        return WebScaffold(
          floatingActionButton: floatingActionButton,
          child: child,
        );
    }
  }
}
