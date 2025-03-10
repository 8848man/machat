part of '../lib.dart';

class ChatContents extends ConsumerWidget {
  const ChatContents({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ChatRoomData> chatState = ref.watch(chatViewModelProvider);
    final ChatViewModel notifier = ref.read(chatViewModelProvider.notifier);

    // 채팅 스트림 프로바이더 가져오기
    final AsyncValue<List<dynamic>> streamProvider =
        ref.watch(chatStreamProvider);

    final Completer completer = ref.watch(cancelCompleterProvider);

    return chatState.when(
      data: (ChatRoomData data) {
        return switch (streamProvider) {
          AsyncData(:final value) => buildMessage(
              value: value,
              data: data,
              completer: completer,
              notifier: notifier,
              context: context,
            ),
          AsyncError(:final error) => Text(error.toString()),
          _ => loadingOvertime(ref),
        };
      },
      error: (error, stackTrace) => const Center(
        child: CircularProgressIndicator(),
      ),
      loading: () => loadingOvertime(ref),
    );
  }

  // 메세지 위젯 빌드
  Widget buildMessage({
    required List<dynamic> value,
    required Completer completer,
    required ChatRoomData data,
    required ChatViewModel notifier,
    required BuildContext context,
  }) {
    if (!completer.isCompleted) {
      completer.complete(); // Future.delayed 무효화
    }
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // 키보드 닫기
        notifier.closeExpand();
      },
      child: ListView.builder(
        // Show messages from bottom to top
        reverse: true,
        itemCount: value.length,
        itemBuilder: (context, index) {
          final user = FirebaseAuth.instance.currentUser;
          final reverseIndex = value.length - 1 - index;
          bool isContinue = false;
          bool isHideProfile = false;
          final Chat chat = Chat(
            createdAt: value[reverseIndex]['createdAt'],
            createdBy: value[reverseIndex]['createdBy'],
            message: value[reverseIndex]['message'],
            isMine: value[reverseIndex]['isMine'],
          );

          // 시간 숨김 여부
          isContinue = shouldHideTime(value, reverseIndex);

          // 프로필 숨김 여부
          isHideProfile = shouldHideProfile(value, reverseIndex);

          final message = chat.message;

          // 메세지를 보낸 사람
          String sender = '';

          // 채팅방 정보와 보낸 사람 id를 비교해 이름을 가져옴
          for (var element in data.membersHistory) {
            if (element.id == chat.createdBy) {
              sender = element.name;
            } else {
              sender = 'Unknown';
            }
          }

          // 로그인되어있지 않을 경우
          if (user == null) {
            return buildOtherMessageContents(
              message: message,
              createdAt: chat.createdAt,
              createdBy: sender,
              isContinue: isContinue,
              isHideProfile: isHideProfile,
            );
          }

          // 채팅 만든 아이디와 로그인된 아이디가 일치할 경우
          if (user.uid == chat.createdBy) {
            return buildMyMessageContents(message, chat.createdAt, isContinue);
          }

          // 기본값
          return buildOtherMessageContents(
            message: message,
            createdAt: chat.createdAt,
            createdBy: sender,
            isContinue: isContinue,
            isHideProfile: isHideProfile,
          );
        },
      ),
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
  Widget buildOtherMessageContents({
    required String message,
    required String createdAt,
    required String createdBy,
    required bool isContinue,
    required bool isHideProfile,
  }) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isHideProfile)
            Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(createdBy)),
          if (!isHideProfile) MCSpace().verticalHalfSpace(),
          SizedBox(
            width: double.infinity,
            height: textHeight,
            child: Row(
              children: [
                MCSpace().horizontalHalfSpace(),
                if (!isHideProfile) const ChatProfile(size: iconSize),
                if (isHideProfile)
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
        // 아직 읽지 않은 사람들 표시
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
