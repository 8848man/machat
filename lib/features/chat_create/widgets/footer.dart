part of '../lib.dart';

class ChatCreateFooter extends ConsumerWidget {
  const ChatCreateFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ChatCreateViewModel notifier =
        ref.read(chatCreateViewModelProvider.notifier);
    return Column(
      children: [
        MCButtons().getPositiveButton(
          title: '만들기',
          onTap: () => notifier.createChatRoomProcess(),
        ),
        MCSpace().verticalSpace(),
        MCButtons().getNegativeButton(
          title: '돌아가기',
          onTap: () => notifier.goHome(),
        ),
      ],
    );
  }
}
