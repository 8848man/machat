part of '../lib.dart';

class ChatCreateHeader extends StatelessWidget {
  const ChatCreateHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        McAppear(
          delayMs: 200,
          child: Text(
            '채팅방을',
            style: TextStyle(
                color: MCColors.$color_blue_70,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
        ),
        McAppear(
          delayMs: 600,
          child: Text(
            '만들어볼까요?',
            style: TextStyle(
                color: MCColors.$color_blue_70,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
