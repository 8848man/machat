part of './lib.dart';

// 모바일 적용 스캐폴드
class MobileScaffold extends StatelessWidget {
  final Widget child;

  const MobileScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: const Text('MaChat'),
      ),
      drawer: const MCDrawer(),
      body: child,
    );
  }
}
