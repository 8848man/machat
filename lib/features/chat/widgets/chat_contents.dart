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
    initController();
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

  void initController() {
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

  @override
  void dispose() {
    _scrollController.removeListener(() => fetchMore());
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ChatViewModel notifier = ref.read(chatViewModelProvider.notifier);

    final List<ChatCommand> commands = ref.watch(chatCommandsProvider);
    // 채팅 컨텐츠 상태 가져오기
    final AsyncValue<ChatContentsModel> chatContentsState =
        ref.watch(chatContentsViewModelProvider);

    // 합성된 챗 스트림 프로바이더 가져오기
    final AsyncValue<List<Map<String, dynamic>>> streamProvider =
        ref.watch<AsyncValue<List<Map<String, dynamic>>>>(
            mergedChatStreamProvider);

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
                  commands: commands,
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
    required List<ChatCommand> commands,
  }) {
    if (!completer.isCompleted) {
      completer.complete(); // Future.delayed 무효화
    }

    final List<dynamic> combinedValue = [...initValue, ...value];
    final List<Chat> chatList = combinedValue.map((e) {
      if (e is Map<String, dynamic>) {
        return Chat.fromJson(e);
      } else {
        // Map이 아닐 경우, 기본값 Chat 생성
        return const Chat();
      }
    }).toList();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // 키보드 닫기
        notifier.closeExpand();
      },
      child: ListView.builder(
        // Show messages from bottom to top
        controller: _scrollController,
        reverse: true,
        itemCount: chatList.length,
        itemBuilder: (context, index) {
          final user = FirebaseAuth.instance.currentUser;
          final reverseIndex = chatList.length - 1 - index;

          // 시간 숨김 여부
          final bool isContinue = shouldHideTime(chatList, reverseIndex);

          List<String> characterNames = getCharacterString(
            commands: commands,
            createdBy: chatList[reverseIndex].createdBy,
          );

          RoomUserData sender = getSender(
            data: data,
            value: chatList[reverseIndex],
            reverseIndex: reverseIndex,
            characters: characterNames,
          );

          final User? currentUser = FirebaseAuth.instance.currentUser;

          // 프로필 숨김 여부
          final bool isHideProfile = shouldHideProfile(chatList, reverseIndex);

          final bool isHidden = isHiddenChat(
            chatList[reverseIndex],
            currentUser?.uid ?? '',
            sender.id ?? '',
          );

          // 차단된 채팅은 표시하지 않음
          if (isHidden) {
            return const SizedBox.shrink();
          }

          final bool isLastMessage = reverseIndex == chatList.length - 1;

          return McAppear(
            key: isLastMessage ? ValueKey(chatList[reverseIndex].id) : null,
            delayMs: 100,
            activeAnimation: isLastMessage,
            child: ChatOptionGestureDetector(
              chatValue: chatList[reverseIndex],
              child: buildMessageWidget(
                chat: chatList[reverseIndex],
                isContinue: isContinue,
                isHideProfile: isHideProfile,
                data: data,
                user: user,
                sender: sender,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildChat({
    required Chat chat,
    required bool isContinue,
    required bool isHideProfile,
    required ChatRoomData data,
    required RoomUserData sender,
    User? user,
  }) {
    const ChatContentsType type = ChatContentsType.chat;
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
    return Column(
      children: [
        Row(
          children: [
            const Spacer(),
            buildChatInfo(true, createdAt, isContinue),
            MCSpace().horizontalHalfSpace(),
            if (type == ChatContentsType.chat)
              ChatBubble(
                isMine: true,
                message: strValue,
                // width: textWidth,
                // height: textHeight,
              ),
            if (type == ChatContentsType.image) ChatImage(url: strValue),
            MCSpace().horizontalHalfSpace(),
          ],
        ),
        MCSpace().verticalHalfSpace(),
      ],
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
    String cleanedStrValue = strValue.replaceAll(RegExp(r'\n{2,}'), '\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isHideProfile)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(sender.name),
          ),
        if (!isHideProfile) MCSpace().verticalHalfSpace(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MCSpace().horizontalHalfSpace(),
            if (!isHideProfile) ChatProfileIcon(size: 40.0, userData: sender),
            if (isHideProfile) const SizedBox(width: 40.0, height: 40.0),
            MCSpace().horizontalHalfSpace(),
            if (type == ChatContentsType.chat)
              ChatBubble(
                isMine: false,
                message: cleanedStrValue,
              ),
            if (type == ChatContentsType.image) ChatImage(url: strValue),
            MCSpace().horizontalHalfSpace(),
            buildChatInfo(false, createdAt, isContinue),
          ],
        ),
        MCSpace().verticalHalfSpace(),
      ],
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
    required Chat chat,
    required bool isContinue,
    required bool isHideProfile,
    required ChatRoomData data,
    required RoomUserData sender,
    User? user,
  }) {
    const ChatContentsType type = ChatContentsType.image;
    final String url = chat.imageUrl;

    // 로그인되어있지 않을 경우
    // 모든 메세지를 상대방 메세지로
    if (user == null) {
      return buildOtherContents(
        strValue: url,
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
        strValue: url,
        createdAt: chat.createdAt,
        isContinue: isContinue,
        type: type,
      );
    }

    // 기본값
    // 내가 보내지 않은 메세지
    return buildOtherContents(
      strValue: url,
      createdAt: chat.createdAt,
      sender: sender,
      isContinue: isContinue,
      isHideProfile: isHideProfile,
      type: type,
    );
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
    required Chat chat,
    required bool isContinue,
    required bool isHideProfile,
    required ChatRoomData data,
    required User? user,
    required RoomUserData sender,
  }) {
    // 데이터 타입이 정의되지 않거나 채팅일 경우
    // 정의되지 않았을 때에도 buildChat을 그리는 이유는
    // 이전 데이터 호환성때문
    if (chat.type == 'chat') {
      return buildChat(
        chat: chat,
        isContinue: isContinue,
        isHideProfile: isHideProfile,
        data: data,
        user: user,
        sender: sender,
      );
    }
    // 데이터 타입이 이미지일 경우
    if (chat.type == 'image') {
      return buildImage(
        chat: chat,
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
