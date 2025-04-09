part of '../lib.dart';

class Firends extends ConsumerWidget {
  const Firends({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Column(
      children: [
        MyInfo(),
        Divider(),
        FriendListWidget(),
      ],
    );
  }
}
