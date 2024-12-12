part of '../lib.dart';

class ChatCreateFooter extends ConsumerWidget {
  const ChatCreateFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ChatCreateViewModel notifier =
        ref.read(chatCreateViewModelProvider.notifier);
    return Column(
      children: [
        createButton(notifier: notifier),
        MCSpace().verticalSpace(),
        goRegisterButton(notifier: notifier),
      ],
    );
  }

  Widget createButton({required ChatCreateViewModel notifier}) {
    return GestureDetector(
      child: Container(
        height: 48,
        width: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: MCColors.$color_blue_40,
        ),
        child: const Center(child: Text('만들기')),
      ),
      onTap: () => notifier.createChatRoomProcess(),
    );
  }

  Widget goRegisterButton({required ChatCreateViewModel notifier}) {
    return GestureDetector(
      child: Container(
        height: 48,
        width: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: MCColors.$color_grey_40,
        ),
        child: const Center(child: Text('돌아가기')),
      ),
      onTap: () => notifier.goHome(),
    );
  }
}
