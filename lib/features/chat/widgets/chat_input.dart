part of '../lib.dart';

class ChatInput extends ConsumerWidget {
  const ChatInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double boxDouble = 60;
    return Container(
      width: double.infinity,
      height: boxDouble,
      color: Colors.amber,
      child: Row(
        children: [
          Container(
            width: boxDouble,
            height: boxDouble,
            color: Colors.red,
          ),
          Container().expand(),
          Container(
            width: boxDouble,
            height: boxDouble,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
