part of './lib.dart';

// 마챗 기본 레이아웃
class DefaultLayout extends StatelessWidget {
  final Widget child;

  const DefaultLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    switch (screenWidth) {
      case <= 760:
        return MobileScaffold(child: child);
      case <= 1240:
        return WebScaffold(child: child);
      default:
        return WebScaffold(child: child);
    }
  }
}
