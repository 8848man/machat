part of '../lib.dart';

class ChatSendingContents extends ConsumerWidget {
  const ChatSendingContents({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final widget = ref.watch(chatSendingWidgetProvider);
    return widget;
  }
}
