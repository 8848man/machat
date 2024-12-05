part of './lib.dart';

// 웹 적용 스캐폴드
class WebScaffold extends StatelessWidget {
  final Widget child;

  const WebScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: child,
    );
  }
}
