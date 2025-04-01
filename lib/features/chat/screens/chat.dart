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
          // 채팅 컨텐츠
          const ChatContents().expand(),
          // 채팅 입력창
          const ChatInput(),
          // 채팅 전송 컨텐츠
          const ChatSendingContents(),
          // 채팅 + 버튼 확장 위젯
          const ChatExpand(),
        ],
      ),
    );
  }
}
