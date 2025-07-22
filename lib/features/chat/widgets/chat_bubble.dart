part of '../lib.dart';

class ChatBubble extends StatelessWidget {
  final bool isMine;
  final String message;
  final double width;
  final double height;
  const ChatBubble({
    super.key,
    required this.isMine,
    required this.message,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
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
          color: isMine == true
              ? MCColors.$color_orange_20
              : MCColors.$color_orange_10,
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
