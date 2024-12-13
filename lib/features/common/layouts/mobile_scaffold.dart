part of './lib.dart';

// 모바일 적용 스캐폴드
class MobileScaffold extends ConsumerWidget {
  final Widget child;
  final Widget? floatingActionButton;

  const MobileScaffold(
      {super.key, required this.child, this.floatingActionButton});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final User? user = FirebaseAuth.instance.currentUser;
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
        title: const Text('MaChat Mobile'),
        actions: getActions(user, ref),
      ),
      drawer: const MCDrawer(),
      body: child,
      floatingActionButton: floatingActionButton,
    );
  }
}
