part of '../lib.dart';

class ChatContents extends ConsumerWidget {
  const ChatContents({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double messageHeight = 48;
    return SingleChildScrollView(
      child: Column(
        children: [
          buildOtherMessageContents(messageHeight),
          buildMyMessageContents(messageHeight),
          buildMyMessageContents(messageHeight),
          buildMyMessageContents(messageHeight),
          buildMyMessageContents(messageHeight),
          buildMyMessageContents(messageHeight),
          buildMyMessageContents(messageHeight),
          buildMyMessageContents(messageHeight),
          buildMyMessageContents(messageHeight),
          buildMyMessageContents(messageHeight),
          buildMyMessageContents(messageHeight),
          buildMyMessageContents(messageHeight),
          buildMyMessageContents(messageHeight),
          MCSpace().verticalHalfSpace(),
        ],
      ),
    );
  }

  Widget buildMyMessageContents(double messageHeight) {
    return Column(
      children: [
        MCSpace().verticalHalfSpace(),
        SizedBox(
          width: double.infinity,
          height: messageHeight,
          child: Row(
            children: [
              const Spacer(),
              SizedBox(
                height: messageHeight,
                width: 250,
                child: buildSpeechBubble(true, 'text'),
              ),
              MCSpace().horizontalHalfSpace(),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildOtherMessageContents(double messageHeight) {
    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth =
          constraints.maxWidth > 300 ? 300.0 : constraints.maxWidth;

      // 텍스트 크기 계산
      final text =
          'my text Messageaaa aaaaaaaaaaaa bababababbba aaaaaaaaaaaa'; // 텍스트를 동적으로 변경 가능
      final textStyle = const TextStyle(fontSize: 16);
      final textPainter = TextPainter(
        text: TextSpan(text: text, style: textStyle),
        maxLines: null, // 여러 줄 허용
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: maxWidth - 16); // 패딩 제외한 maxWidth

      // 텍스트 크기 기반으로 동적 높이 계산
      final textHeight = textPainter.size.height + 16;
      final textWidth = textPainter.size.width + 16;
      return Column(
        children: [
          MCSpace().verticalHalfSpace(),
          SizedBox(
            width: double.infinity,
            height: textHeight,
            child: Row(
              children: [
                MCSpace().horizontalHalfSpace(),
                Container(
                  height: textHeight,
                  width: textHeight,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                      colors: [
                        Color(0xff4dabf7),
                        Color(0xffda77f2),
                        Color(0xfff783ac),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(500),
                  ),
                  child: const CircleAvatar(
                    radius: 250,
                    // backgroundImage: AssetImage("assets/images/person-winter.png"),
                  ),
                ),
                MCSpace().horizontalHalfSpace(),
                SizedBox(
                  height: textHeight,
                  width: textWidth,
                  child: buildSpeechBubble(false, text),
                ),
              ],
            ),
          ),
        ],
      );
    });
    // return Column(
    //   children: [
    //     MCSpace().verticalHalfSpace(),
    //     SizedBox(
    //       width: double.infinity,
    //       height: messageHeight,
    //       child: Row(
    //         children: [
    //           MCSpace().horizontalHalfSpace(),
    //           Container(
    //             height: messageHeight,
    //             width: messageHeight,
    //             padding: const EdgeInsets.all(2),
    //             decoration: BoxDecoration(
    //               gradient: const LinearGradient(
    //                 begin: Alignment.bottomRight,
    //                 end: Alignment.topLeft,
    //                 colors: [
    //                   Color(0xff4dabf7),
    //                   Color(0xffda77f2),
    //                   Color(0xfff783ac),
    //                 ],
    //               ),
    //               borderRadius: BorderRadius.circular(500),
    //             ),
    //             child: const CircleAvatar(
    //               radius: 250,
    //               // backgroundImage: AssetImage("assets/images/person-winter.png"),
    //             ),
    //           ),
    //           MCSpace().horizontalHalfSpace(),
    //           SizedBox(
    //             height: messageHeight,
    //             width: 250,
    //             child: buildSpeechBubble(false),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }

  Widget buildSpeechBubble(bool isMine, String message) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(8),
          topRight: const Radius.circular(8),
          bottomLeft: isMine == true ? const Radius.circular(8) : Radius.zero,
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
    );
  }

  // Widget buildSpeechBubble(bool isMine) {
  //   return LayoutBuilder(
  //     builder: (context, constraints) {
  //       final maxWidth =
  //           constraints.maxWidth > 300 ? 300.0 : constraints.maxWidth;

  //       // 텍스트 크기 계산
  //       final text = 'my text Message'; // 텍스트를 동적으로 변경 가능
  //       final textStyle = const TextStyle(fontSize: 16);
  //       final textPainter = TextPainter(
  //         text: TextSpan(text: text, style: textStyle),
  //         maxLines: null, // 여러 줄 허용
  //         textDirection: TextDirection.ltr,
  //       )..layout(maxWidth: maxWidth - 16); // 패딩 제외한 maxWidth

  //       // 텍스트 크기 기반으로 동적 높이 계산
  //       final textHeight = textPainter.size.height;
  //       final textWidth = textPainter.size.width;

  //       return SizedBox(
  //         width: textWidth + 16, // 텍스트 너비 + 패딩
  //         height: textHeight + 16, // 텍스트 높이 + 패딩
  //         child: Container(
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.only(
  //               topLeft: const Radius.circular(8),
  //               topRight: const Radius.circular(8),
  //               bottomLeft:
  //                   isMine == true ? const Radius.circular(8) : Radius.zero,
  //               bottomRight:
  //                   isMine == true ? Radius.zero : const Radius.circular(8),
  //             ),
  //             color: Colors.amber,
  //           ),
  //           child: Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Text(
  //               text,
  //               style: textStyle,
  //               softWrap: true, // 줄바꿈 활성화
  //               overflow: TextOverflow.visible, // 텍스트 넘침 방지
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
