part of '../lib.dart';

class Friends extends ConsumerWidget {
  const Friends({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const MyInfo(),
        const Divider(),
        const FriendListWidget().expand(),
      ],
    );
  }
}
