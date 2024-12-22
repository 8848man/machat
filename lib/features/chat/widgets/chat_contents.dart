part of '../lib.dart';

class ChatContents extends ConsumerWidget {
  const ChatContents({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 채팅 스트림 프로바이더 가져오기
    final streamProvider = ref.watch(chatStreamProvider);

    // 스트림 상태에 따른 위젯 변환
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
        bool isContinue = false;
        final Chat chat = Chat(
          createdAt: value[reverseIndex]['createdAt'],
          createdBy: value[reverseIndex]['createdBy'],
          message: value[reverseIndex]['message'],
          isMine: value[reverseIndex]['isMine'],
        );

        // 시간과 프로필 숨김 여부
        isContinue = shouldHideTimeAndProfile(value, reverseIndex);

        // 로그인되어있지 않을 경우
        if (user == null) {
          return buildOtherMessageContents(
              chat.message, chat.createdAt, isContinue);
        }

        // 채팅 만든 아이디와 로그인된 아이디가 일치할 경우
        if (user.uid == chat.createdBy) {
          return buildMyMessageContents(
              '${chat.message} $reverseIndex', chat.createdAt, isContinue);
        }

        // 기본값
        return buildOtherMessageContents(
            chat.message, chat.createdAt, isContinue);
      },
    );
  }

  // 내가 보낸 메세지 위젯 빌드
  Widget buildMyMessageContents(
      String message, String createdAt, bool isContinue) {
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

      // 채팅 위젯 빌드
      return Column(
        children: [
          // 채팅 위젯
          SizedBox(
            width: double.infinity,
            height: textHeight,
            // 내가 보낸 메세지는 오른쪽 정렬
            child: Row(
              children: [
                const Spacer(),
                // 채팅 정보
                buildChatInfo(true, createdAt, isContinue),
                MCSpace().horizontalHalfSpace(),
                // 채팅 버블
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

  // 다른 사람이 보낸 메세지 위젯 빌드
  Widget buildOtherMessageContents(
      String message, String createdAt, bool isContinue) {
    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth =
          constraints.maxWidth > 300 ? 300.0 : constraints.maxWidth;

      const iconSize = 40.0;
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
                if (!isContinue) const ChatProfile(size: iconSize),
                if (isContinue)
                  const SizedBox(width: iconSize, height: iconSize),
                MCSpace().horizontalHalfSpace(),
                ChatBubble(isMine: false, message: text, size: textWidth),
                MCSpace().horizontalHalfSpace(),
                buildChatInfo(false, createdAt, isContinue),
              ],
            ),
          ),
          MCSpace().verticalHalfSpace(),
        ],
      );
    });
  }

  // 채팅 정보 위젯
  Widget buildChatInfo(bool isMine, String? time, bool isContinue) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment:
          isMine == true ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        // 아직 읽지 않은 사람들들 표시
        // const Text('1', style: TextStyle(fontSize: 12)),
        // MCSpace().verticalHalfSpace(),
        // 시간
        if (!isContinue)
          Text(chatFormatTimestamp(time ?? ''),
              style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
