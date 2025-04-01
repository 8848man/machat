part of './lib.dart';

// 모바일 적용 스캐폴드
class MobileScaffold extends ConsumerWidget {
  final Widget child;
  final Widget? floatingActionButton;
  final String? title;

  const MobileScaffold(
      {super.key, required this.child, this.floatingActionButton, this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        // leading: Builder(
        //   builder: (context) {
        //     return IconButton(
        //       icon: const Icon(Icons.arrow_back),
        //       onPressed: () {
        //         Navigator.of(context).pop();
        //       },
        //     );
        //   },
        // ),
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
        title: Text(title ?? 'MaChat Mobile'),
      ),
      drawer: const MCDrawer(),
      body: child,
      floatingActionButton: floatingActionButton,
    );
  }
}
