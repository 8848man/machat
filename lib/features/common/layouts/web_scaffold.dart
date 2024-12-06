part of './lib.dart';

// 웹 적용 스캐폴드
class WebScaffold extends StatelessWidget {
  final Widget child;
  final Widget? floatingActionButton;

  const WebScaffold(
      {super.key, required this.child, this.floatingActionButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: floatingActionButton,
      body: child,
    );
  }
}
