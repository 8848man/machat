part of '../lib.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // chatContents 상태와 상관 없이 포커스노드를 유지하기 위한 read
    ref.read(chatFocusNodeProvider);
    return DefaultLayout(
      child: Column(
        children: [
          // const ChatContents().expand(),
          const ChatContentsCopy().expand(),
          const ChatInput(),
          const ChatExpand(),
        ],
      ),
    );
  }
}
