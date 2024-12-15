part of '../lib.dart';

class ChatInput extends ConsumerWidget {
  const ChatInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ChatViewModel notifier = ref.read(chatViewModelProvider.notifier);
    const double boxDouble = 60;
    return Container(
      width: double.infinity,
      height: boxDouble,
      color: MCColors.$color_grey_30,
      child: Row(
        children: [
          buildAttatchButton(boxDouble),
          buildTextInput(notifier).expand(),
          buildSendMessage(boxDouble, notifier),
        ],
      ),
    );
  }

  Widget buildAttatchButton(double boxDouble) {
    return SizedBox(
      width: boxDouble,
      height: boxDouble,
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
    );
  }

  Widget buildTextInput(ChatViewModel notifier) {
    return MCTextInput(
      controller: notifier.messageController,
      labelText: '메세지를 입력해주세요',
      backgroundColor: MCColors.$color_grey_00,
      onSubmitted: (value) => notifier.sendMessageProcess(),
    );
  }

  Widget buildSendMessage(double boxDouble, ChatViewModel notifier) {
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
      onTap: () => notifier.sendMessageProcess(),
    );
  }
}
