part of '../lib.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

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
