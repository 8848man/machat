part of '../lib.dart';

class Chat extends StatelessWidget {
  const Chat({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(
      child: Column(
        children: [
          ChatContents(),
          ChatInput(),
        ],
      ),
    );
  }
}
