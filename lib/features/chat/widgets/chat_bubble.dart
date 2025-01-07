part of '../lib.dart';

class ChatBubble extends StatelessWidget {
  final bool isMine;
  final String message;
  final double size;
  const ChatBubble({
    super.key,
    required this.isMine,
    required this.message,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: isMine == true ? const Radius.circular(8) : Radius.zero,
            topRight: const Radius.circular(8),
            bottomLeft: const Radius.circular(8),
            bottomRight: isMine == true
                ? Radius.zero
                : const Radius.circular(8), // 우측 하단은 제외
          ),
          color: Colors.amber,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(message),
          ),
        ),
      ),
    );
  }
}
