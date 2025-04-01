part of '../lib.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '홈',
      // floatingActionButton: AnimatedFAB(),
      floatingActionButton: Transform.translate(
        offset: const Offset(0, -100), // 20픽셀 위로 이동
        child: const AnimatedFAB(),
      ),
      child: const Center(
        child: HomeBundle(),
      ),
    );
  }
}
