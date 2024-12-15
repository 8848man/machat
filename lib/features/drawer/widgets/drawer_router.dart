part of '../lib.dart';

class DrawerRouter extends ConsumerWidget {
  const DrawerRouter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(mCDrawerViewModelProvider.notifier);
    return ListTile(
        title: Row(
          children: [
            const Icon(Icons.home),
            MCSpace().horizontalHalfSpace(),
            const Text('홈'),
          ],
        ),
        onTap: () => notifier.goHome());
  }
}
