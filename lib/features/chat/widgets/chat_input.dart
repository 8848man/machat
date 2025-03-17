part of '../lib.dart';

class ChatInput extends ConsumerWidget {
  const ChatInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ExpandWidgetState expandWidgetState =
        ref.watch(expandWidgetStateProvider);
    const double boxDouble = 60;
    // ExpandWidget 상태가 닫혀있거나, 그냥 열려있을 경우에만 normal 상태
    final isNormal = expandWidgetState == ExpandWidgetState.collapsed ||
        expandWidgetState == ExpandWidgetState.expanded;

    return buildInputContainer(context, boxDouble, ref, isNormal);
  }

  Widget buildInputContainer(
    BuildContext context,
    double boxDouble,
    WidgetRef ref,
    bool isNormal,
  ) {
    return Container(
      width: double.infinity,
      height: boxDouble,
      color: MCColors.$color_grey_10,
      child: Row(
        children: [
          buildAttatchButton(boxDouble, ref),
          if (isNormal) buildTextInput(context, ref).expand(), // 조건부 추가
          if (!isNormal) const Spacer(),
          buildSendMessage(boxDouble, ref),
        ],
      ),
    );
  }

  // 추가 컨텐츠 붙이기 버튼
  Widget buildAttatchButton(double boxDouble, WidgetRef ref) {
    return SizedBox(
      width: boxDouble,
      height: boxDouble,
      child: GestureDetector(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: MCColors.$color_blue_40,
            ),
            child: const Center(
              child: Text('+'),
            ),
          ),
        ),
        onTap: () {
          final notifier = ref.read(expandWidgetStateProvider.notifier);
          // 현재 위젯 상태가 닫혀있으면 열고, 열려있으면 닫기
          notifier.state = notifier.state == ExpandWidgetState.collapsed
              ? ExpandWidgetState.expanded
              : ExpandWidgetState.collapsed;
          // 현재 키보드가 올라와 있으면 닫기
          FocusManager.instance.primaryFocus?.unfocus();
        },
      ),
    );
  }

  // 메세지 입력칸
  Widget buildTextInput(BuildContext context, WidgetRef ref) {
    final ChatViewModel notifier = ref.read(chatViewModelProvider.notifier);
    return MCTextInput(
      controller: notifier.messageController,
      labelText: '메세지를 입력해주세요',
      backgroundColor: MCColors.$color_grey_00,
      onSubmitted: (value) {
        notifier.sendMessageProcess();
        // 메세지 보낸 후에도 focus 유지
        FocusScope.of(context).requestFocus(notifier.focusNode);
      },
      focusNode: notifier.focusNode,
    );
  }

  // 메세지 보내기 버튼
  Widget buildSendMessage(double boxDouble, WidgetRef ref) {
    late final ChatViewModelInterface notifier;

    notifier = getNotifier(ref);
    return GestureDetector(
      child: SizedBox(
        width: boxDouble,
        height: boxDouble,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: MCColors.$color_blue_40,
            ),
            child: const Icon(
              IconData(0xe571,
                  fontFamily: 'MaterialIcons', matchTextDirection: true),
            ),
          ),
        ),
      ),
      onTap: () => notifier.sendData(),
    );
  }

  // 현재 페이지 상태에 따른 뷰모델 노티파이어 할당
  ChatViewModelInterface getNotifier(WidgetRef ref) {
    final ExpandWidgetState expandWidgetState =
        ref.watch(expandWidgetStateProvider);

    // 사진 페이지 상태일 때, ImageViewModel 호출
    if (expandWidgetState == ExpandWidgetState.picture) {
      return ref.read(chatImageViewModelProvider.notifier);
    }

    // 기본적으로 ChatViewModel 호출
    return ref.read(chatViewModelProvider.notifier);
  }
}
