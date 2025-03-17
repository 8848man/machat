part of '../lib.dart';

class ChatContents extends ConsumerWidget {
  const ChatContents({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ChatRoomData> chatState = ref.watch(chatViewModelProvider);
    final ChatViewModel notifier = ref.read(chatViewModelProvider.notifier);

    // 합성된 챗 스트림 프로바이더 가져오기
    final AsyncValue<List<dynamic>> streamProvider =
        ref.watch(mergedChatStreamProvider);

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
          // 시간 숨김 여부
          final bool isContinue = shouldHideTime(value, reverseIndex);

          // 메세지를 보낸 사람
          String sender = '';

          // 채팅방 정보와 보낸 사람 id를 비교해 이름을 가져옴
          for (var element in data.membersHistory) {
            if (element.id == value[reverseIndex]['createdBy']) {
              sender = element.name;
            } else {
              sender = '알 수 없는 사용자';
            }
          }

          // 프로필 숨김 여부
          final bool isHideProfile = shouldHideProfile(value, reverseIndex);

          // 데이터 타입이 정의되지 않거나 채팅일 경우
          // 정의되지 않았을 때에도 buildChat을 그리는 이유는
          // 이전 데이터 호환성때문
          if (value[reverseIndex]['type'] == null ||
              value[reverseIndex]['type'] == 'chat') {
            return buildChat(
              value: value,
              reverseIndex: reverseIndex,
              isContinue: isContinue,
              isHideProfile: isHideProfile,
              data: data,
              user: user,
              sender: sender,
            );
          }
          // 데이터 타입이 이미지일 경우
          if (value[reverseIndex]['type'] == 'image') {
            return buildImage(
              value: value,
              reverseIndex: reverseIndex,
              isContinue: isContinue,
              isHideProfile: isHideProfile,
              data: data,
              user: user,
              sender: sender,
            );
          }

          // 정의되지 않은 데이터, 기본값 : 표기하지 않음
          return Container();
        },
      ),
    );
  }

  Widget buildChat({
    required List<dynamic> value,
    required int reverseIndex,
    required bool isContinue,
    required bool isHideProfile,
    required ChatRoomData data,
    required String sender,
    User? user,
  }) {
    const ChatContentsType type = ChatContentsType.chat;
    final Chat chat = Chat(
      createdAt: value[reverseIndex]['createdAt'],
      createdBy: value[reverseIndex]['createdBy'],
      message: value[reverseIndex]['message'],
      isMine: value[reverseIndex]['isMine'],
    );
    final String message = chat.message;

    // 로그인되어있지 않을 경우
    // 모든 메세지를 상대방 메세지로
    if (user == null) {
      return buildOtherContents(
        strValue: message,
        createdAt: chat.createdAt,
        createdBy: sender,
        isContinue: isContinue,
        isHideProfile: isHideProfile,
        type: type,
      );
    }

    // 채팅 만든 아이디와 로그인된 아이디가 일치할 경우
    if (user.uid == chat.createdBy) {
      return buildMyContents(
        strValue: message,
        createdAt: chat.createdAt,
        isContinue: isContinue,
        type: type,
      );
    }

    // 기본값
    // 내가 보내지 않은 메세지
    return buildOtherContents(
      strValue: message,
      createdAt: chat.createdAt,
      createdBy: sender,
      isContinue: isContinue,
      isHideProfile: isHideProfile,
      type: type,
    );
  }

  Widget buildMyContents({
    required String strValue,
    required String createdAt,
    required bool isContinue,
    required ChatContentsType type,
  }) {
    return buildBubbleLayout(
      message: strValue,
      child: (textWidth, textHeight) {
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: textHeight,
              child: Row(
                children: [
                  const Spacer(),
                  buildChatInfo(true, createdAt, isContinue),
                  MCSpace().horizontalHalfSpace(),
                  if (type == ChatContentsType.chat)
                    ChatBubble(
                        isMine: true, message: strValue, size: textWidth),
                  if (type == ChatContentsType.image)
                    ChatImage(
                      url: strValue,
                    ),
                  MCSpace().horizontalHalfSpace(),
                ],
              ),
            ),
            MCSpace().verticalHalfSpace(),
          ],
        );
      },
    );
  }

  // 다른 사람이 보낸 컨텐츠 위젯
  Widget buildOtherContents({
    required String strValue,
    required String createdAt,
    required String createdBy,
    required bool isContinue,
    required bool isHideProfile,
    required ChatContentsType type,
  }) {
    return buildBubbleLayout(
      message: strValue,
      child: (textWidth, textHeight) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isHideProfile)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(createdBy),
              ),
            if (!isHideProfile) MCSpace().verticalHalfSpace(),
            SizedBox(
              width: double.infinity,
              height: textHeight,
              child: Row(
                children: [
                  MCSpace().horizontalHalfSpace(),
                  if (!isHideProfile) const ChatProfile(size: 40.0),
                  if (isHideProfile) const SizedBox(width: 40.0, height: 40.0),
                  MCSpace().horizontalHalfSpace(),
                  if (type == ChatContentsType.chat)
                    ChatBubble(
                        isMine: false, message: strValue, size: textWidth),
                  if (type == ChatContentsType.image)
                    ChatImage(
                      url: strValue,
                    ),
                  MCSpace().horizontalHalfSpace(),
                  buildChatInfo(false, createdAt, isContinue),
                ],
              ),
            ),
            MCSpace().verticalHalfSpace(),
          ],
        );
      },
    );
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

  // 채팅 버블 레이아웃
  Widget buildBubbleLayout({
    required String message,
    required Widget Function(double textWidth, double textHeight) child,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth =
            constraints.maxWidth > 300 ? 300.0 : constraints.maxWidth;

        // 텍스트 크기 계산
        const textStyle = TextStyle(fontSize: 16);
        final textPainter = TextPainter(
          text: TextSpan(text: message, style: textStyle),
          maxLines: null, // 여러 줄 허용
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: maxWidth - 16);

        // 텍스트 크기 기반으로 동적 높이 계산
        final textHeight = textPainter.size.height + 20;
        final textWidth = textPainter.size.width + 20;

        return child(textWidth, textHeight);
      },
    );
  }

  Widget buildImage({
    required List<dynamic> value,
    required int reverseIndex,
    required bool isContinue,
    required bool isHideProfile,
    required ChatRoomData data,
    required String sender,
    User? user,
  }) {
    const ChatContentsType type = ChatContentsType.image;
    final McImage image = McImage(
      createdAt: value[reverseIndex]['createdAt'],
      createdBy: value[reverseIndex]['createdBy'],
      imageUrl: value[reverseIndex]['imageUrl'],
      isMine: value[reverseIndex]['isMine'],
    );
    final String url = image.imageUrl;

    // 로그인되어있지 않을 경우
    // 모든 메세지를 상대방 메세지로
    if (user == null) {
      return buildOtherContents(
        strValue: url,
        createdAt: image.createdAt,
        createdBy: image.createdBy,
        isContinue: isContinue,
        isHideProfile: isHideProfile,
        type: type,
      );
    }

    // 채팅 만든 아이디와 로그인된 아이디가 일치할 경우
    if (user.uid == image.createdBy) {
      return buildMyContents(
        strValue: url,
        createdAt: image.createdAt,
        isContinue: isContinue,
        type: type,
      );
    }

    // 기본값
    // 내가 보내지 않은 메세지
    return buildOtherContents(
      strValue: url,
      createdAt: image.createdAt,
      createdBy: sender,
      isContinue: isContinue,
      isHideProfile: isHideProfile,
      type: type,
    );
  }
}
