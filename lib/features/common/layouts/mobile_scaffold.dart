part of './lib.dart';

// 모바일 적용 스캐폴드
class MobileScaffold extends ConsumerWidget {
  final Widget child;
  final Widget? floatingActionButton;
  final String? title;
  final List<Widget>? actions;
  final Widget? drawer;
  final Widget? endDrawer;

  const MobileScaffold({
    super.key,
    required this.child,
    this.floatingActionButton,
    this.title,
    this.actions,
    this.drawer,
    this.endDrawer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        // leading: Navigator.canPop(context)
        //     ? IconButton(
        //         icon: const Icon(Icons.arrow_back),
        //         onPressed: () {
        //           if (Navigator.canPop(context)) {
        //             Navigator.pop(context);
        //           }
        //         },
        //       )
        //     : null, // 뒤로 갈 페이지가 없으면 leading 제거,
        leading: const SizedBox(),
        leadingWidth: 0,
        title: Text(title ?? 'MaChat Mobile'),
        actions: actions ?? [],
      ),
      drawer: drawer,
      endDrawer: endDrawer,
      body: child,
      floatingActionButton: floatingActionButton,
    );
  }
}
