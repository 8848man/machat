part of '../lib.dart';

class ChatContents extends ConsumerWidget {
  const ChatContents({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streamProvider = ref.watch(chatStreamProvider);

    return switch (streamProvider) {
      AsyncData(:final value) => buildMessage(value),
      AsyncError(:final error) => Text(error.toString()),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }

  // 메세지 위젯 빌드
  Widget buildMessage(List<dynamic> value) {
    return ListView.builder(
      // Show messages from bottom to top
      reverse: true,
      itemCount: value.length,
      itemBuilder: (context, index) {
        final user = FirebaseAuth.instance.currentUser;
        final reverseIndex = value.length - 1 - index;
        final Chat chat = Chat(
          createdAt: value[reverseIndex]['createdAt'],
          createdBy: value[reverseIndex]['createdBy'],
          message: value[reverseIndex]['message'],
          isMine: value[reverseIndex]['isMine'],
        );

        // 로그인되어있지 않을 경우
        if (user == null) {
          return buildOtherMessageContents(chat.message, chat.createdAt);
        }

        // 채팅 만든 아이디와 로그인된 아이디가 일치할 경우
        if (user.uid == chat.createdBy) {
          return buildMyMessageContents(chat.message, chat.createdAt);
        }

        // 기본값
        return buildOtherMessageContents(chat.message, chat.createdAt);
      },
    );
  }

  Widget buildMyMessageContents(String message, String createdAt) {
    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth =
          constraints.maxWidth > 300 ? 300.0 : constraints.maxWidth;

      // 텍스트 크기 계산
      final String text = message; // 텍스트를 동적으로 변경 가능
      const textStyle = TextStyle(fontSize: 16);
      final textPainter = TextPainter(
        text: TextSpan(text: text, style: textStyle),
        maxLines: null, // 여러 줄 허용
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: maxWidth - 16); // 패딩 제외한 maxWidth

      // 텍스트 크기 기반으로 동적 높이 계산
      final textHeight = textPainter.size.height + 20;
      final textWidth = textPainter.size.width + 20;

      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: textHeight,
            child: Row(
              children: [
                const Spacer(),
                chatInfo(true, createdAt),
                MCSpace().horizontalHalfSpace(),
                ChatBubble(isMine: true, message: text, size: textWidth),
                MCSpace().horizontalHalfSpace(),
              ],
            ),
          ),
          MCSpace().verticalHalfSpace(),
        ],
      );
    });
  }

  Widget buildOtherMessageContents(String message, String createdAt) {
    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth =
          constraints.maxWidth > 300 ? 300.0 : constraints.maxWidth;

      // 텍스트 크기 계산
      final text = message; // 텍스트를 동적으로 변경 가능
      const textStyle = TextStyle(fontSize: 16);
      final textPainter = TextPainter(
        text: TextSpan(text: text, style: textStyle),
        maxLines: null, // 여러 줄 허용
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: maxWidth - 16); // 패딩 제외한 maxWidth

      // 텍스트 크기 기반으로 동적 높이 계산
      final textHeight = textPainter.size.height + 20;
      final textWidth = textPainter.size.width + 20;
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: textHeight,
            child: Row(
              children: [
                MCSpace().horizontalHalfSpace(),
                ChatProfile(size: textHeight),
                MCSpace().horizontalHalfSpace(),
                ChatBubble(isMine: false, message: text, size: textWidth),
                MCSpace().horizontalHalfSpace(),
                chatInfo(false, createdAt),
              ],
            ),
          ),
          MCSpace().verticalHalfSpace(),
        ],
      );
    });
  }

  Widget chatInfo(bool isMine, String? time) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment:
          isMine == true ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        // 아직 읽지 않은 사람들들
        // const Text('1', style: TextStyle(fontSize: 12)),
        // MCSpace().verticalHalfSpace(),
        Text(chatFormatTimestamp(time ?? ''),
            style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
