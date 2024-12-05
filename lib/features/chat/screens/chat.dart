part of '../lib.dart';

class Chat extends StatelessWidget {
  const Chat({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Column(
        children: [
          const ChatContents().expand(),
          const ChatInput(),
        ],
      ),
    );
  }
}
