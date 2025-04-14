part of './lib.dart';

// 웹 적용 스캐폴드
class WebScaffold extends ConsumerWidget {
  final Widget child;
  final Widget? floatingActionButton;
  final String? title;

  const WebScaffold(
      {super.key, required this.child, this.floatingActionButton, this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
              )
            : null, // 뒤로 갈 페이지가 없으면 leading 제거,
        title: Text(title ?? 'MaChat Web'),
        // actions: getActions(user, ref),
      ),
      // drawer: const MCDrawer(),
      body: child,
      floatingActionButton: floatingActionButton,
    );
  }
}
