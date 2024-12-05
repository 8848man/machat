part of '../lib.dart';

// 통신간 로딩중일 때 로딩 상태 나타내는 공통 위젯
class LoadingWidget extends ConsumerWidget {
  const LoadingWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loadingProvider);

    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: MCColors.$color_grey_40,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
