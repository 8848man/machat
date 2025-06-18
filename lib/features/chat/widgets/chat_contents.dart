part of '../lib.dart';

class ChatContents extends ConsumerStatefulWidget {
  const ChatContents({super.key});

  @override
  ConsumerState<ChatContents> createState() => _ChatContentsState();
}

class _ChatContentsState extends ConsumerState<ChatContents>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  bool _isFetching = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() async => fetchMore());
  }

  Future<void> fetchMore() async {
    // 스크롤이 최상단에 닿았을 때
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 50 &&
        !_isFetching) {
      setFetching(true);
      final vm = ref.read(chatContentsViewModelProvider.notifier);
      final state = await ref.read(chatContentsViewModelProvider.future);

      if (state.hasMore && state.lastDoc != null) {
        await vm.fetchPreviousChats(
          roomId: state.roomData.roomId,
          lastDoc: state.lastDoc!,
        );
      }

      setFetching(false);
    }

    // 애니메이션 컨트롤러
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // 애니메이션 정의
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1), // 화면 위쪽에서 시작
      end: Offset.zero, // 제자리로
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack, // 통 튀듯한 느낌
    ));
  }

  void setFetching(bool value) {
    setState(() {
      _isFetching = value;
      if (value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ChatViewModel notifier = ref.read(chatViewModelProvider.notifier);

    // 채팅 컨텐츠 상태 가져오기
    final AsyncValue<ChatContentsModel> chatContentsState =
        ref.watch(chatContentsViewModelProvider);

    // 합성된 챗 스트림 프로바이더 가져오기
    final AsyncValue<List<dynamic>> streamProvider =
        ref.watch(mergedChatStreamProvider);

    final Completer completer = ref.watch(cancelCompleterProvider);

    return chatContentsState.when(
      data: (ChatContentsModel data) {
        return switch (streamProvider) {
          AsyncData(:final value) => Stack(
              children: [
                buildContents(
                  initValue: data.contents,
                  value: value,
                  data: data.roomData,
                  completer: completer,
                  notifier: notifier,
                  context: context,
                ),
                // 채팅방 데이터를 가져오는 도중에는 로딩 위젯 표시
                if (_isFetching) fetchLoading(),
              ],
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
  Widget buildContents({
    required List<dynamic> initValue,
    required List<dynamic> value,
    required Completer completer,
    required ChatRoomData data,
    required ChatViewModel notifier,
    required BuildContext context,
  }) {
    if (!completer.isCompleted) {
      completer.complete(); // Future.delayed 무효화
    }

    final List<dynamic> combinedValue = [...initValue, ...value];

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // 키보드 닫기
        notifier.closeExpand();
      },
      child: ListView.builder(
        // Show messages from bottom to top
        controller: _scrollController,
        reverse: true,
        itemCount: combinedValue.length,
        itemBuilder: (context, index) {
          final user = FirebaseAuth.instance.currentUser;
          final reverseIndex = combinedValue.length - 1 - index;

          // 시간 숨김 여부
          final bool isContinue = shouldHideTime(combinedValue, reverseIndex);

          RoomUserData sender = getSender(
              data: data, value: combinedValue, reverseIndex: reverseIndex);

          final User? currentUser = FirebaseAuth.instance.currentUser;

          // 프로필 숨김 여부
          final bool isHideProfile =
              shouldHideProfile(combinedValue, reverseIndex);

          final bool isHidden = isHiddenChat(
            combinedValue[reverseIndex],
            currentUser?.uid ?? '',
            sender.id ?? '',
          );

          // 차단된 채팅은 표시하지 않음
          if (isHidden) {
            return const SizedBox.shrink();
          }

          return ChatOptionGestureDetector(
            chatValue: combinedValue[reverseIndex],
            child: buildMessageWidget(
              combinedValue: combinedValue,
              reverseIndex: reverseIndex,
              isContinue: isContinue,
              isHideProfile: isHideProfile,
              data: data,
              user: user,
              sender: sender,
            ),
          );
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
    required RoomUserData sender,
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
        sender: sender,
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
      sender: sender,
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
                  if (type == ChatContentsType.image) ChatImage(url: strValue),
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
    required RoomUserData sender,
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
                child: Text(sender.name),
              ),
            if (!isHideProfile) MCSpace().verticalHalfSpace(),
            SizedBox(
              width: double.infinity,
              height: textHeight,
              child: Row(
                children: [
                  MCSpace().horizontalHalfSpace(),
                  if (!isHideProfile)
                    ChatProfileIcon(size: 40.0, userData: sender),
                  if (isHideProfile) const SizedBox(width: 40.0, height: 40.0),
                  MCSpace().horizontalHalfSpace(),
                  if (type == ChatContentsType.chat)
                    ChatBubble(
                        isMine: false, message: strValue, size: textWidth),
                  if (type == ChatContentsType.image) ChatImage(url: strValue),
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
    required RoomUserData sender,
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
        sender: sender,
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
      sender: sender,
      isContinue: isContinue,
      isHideProfile: isHideProfile,
      type: type,
    );
  }

  RoomUserData getSender({
    required ChatRoomData data,
    required List<dynamic> value,
    required int reverseIndex,
  }) {
    // 채팅방 정보와 보낸 사람 id를 비교해 이름을 가져옴
    for (RoomUserData element in data.membersHistory) {
      if (element.id == value[reverseIndex]['createdBy']) {
        return element;
      }
    }

    return const RoomUserData(name: '알 수 없는 사용자');
  }

  Widget fetchLoading() {
    // return const Center(
    //   child: CircularProgressIndicator(),
    // );
    return Positioned(
      top: 20,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _offsetAnimation,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget buildMessageWidget({
    required List<dynamic> combinedValue,
    required int reverseIndex,
    required bool isContinue,
    required bool isHideProfile,
    required ChatRoomData data,
    required User? user,
    required RoomUserData sender,
  }) {
    // 데이터 타입이 정의되지 않거나 채팅일 경우
    // 정의되지 않았을 때에도 buildChat을 그리는 이유는
    // 이전 데이터 호환성때문
    if (combinedValue[reverseIndex]['type'] == null ||
        combinedValue[reverseIndex]['type'] == 'chat') {
      return buildChat(
        value: combinedValue,
        reverseIndex: reverseIndex,
        isContinue: isContinue,
        isHideProfile: isHideProfile,
        data: data,
        user: user,
        sender: sender,
      );
    }
    // 데이터 타입이 이미지일 경우
    if (combinedValue[reverseIndex]['type'] == 'image') {
      return buildImage(
        value: combinedValue,
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
  }
}
