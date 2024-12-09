part of '../lib.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(
      floatingActionButton: AnimatedFAB(),
      child: Center(
        child: HomeBundle(),
      ),
    );
  }
}
