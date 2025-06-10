import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/features/chat/features/expand/models/chat_image_button_config.dart';
import 'package:machat/features/chat/features/expand/view_models/chat_image_view_model.dart';

class ChatExpandSelector extends ConsumerStatefulWidget {
  const ChatExpandSelector({super.key});

  @override
  ConsumerState<ChatExpandSelector> createState() => ChatExpandSelectorState();
}

class ChatExpandSelectorState extends ConsumerState<ChatExpandSelector> {
  late ChatImageViewModel notifier;

  @override
  Widget build(BuildContext context) {
    notifier = ref.read(chatImageViewModelProvider.notifier);

    return expandGridView();
  }

  // 추가 기능 모음
  Widget expandGridView() {
    return Container(
      color: MCColors.$color_grey_10,
      margin: const EdgeInsets.all(10),
      child: GridView.count(
        crossAxisCount: 5, // 한 줄에 최대 3개씩 배치 (원하는 개수로 변경 가능)
        crossAxisSpacing: 10, // 가로 간격
        mainAxisSpacing: 10, // 세로 간격
        shrinkWrap: true, // GridView가 내용에 맞게 크기를 조정하도록 설정
        physics: const NeverScrollableScrollPhysics(), // 부모 스크롤과 충돌 방지
        children: List.generate(
          imageButtonData.length,
          (index) => getImageButton(index: index),
        ),
      ),
    );
  }

  // 버튼 목록 정의
  final List<ImageButtonConfig> imageButtonData = [
    ImageButtonConfig(
      icon: Icons.add_a_photo,
      onPressed: (notifier) async => await notifier.getFromCamera(),
    ),
    ImageButtonConfig(
      icon: Icons.add_photo_alternate_outlined,
      onPressed: (notifier) async => await notifier.getFromGallary(),
    ),
  ];

  // 버튼 생성 함수
  Widget getImageButton({
    required int index,
  }) {
    if (index < 0 || index >= imageButtonData.length) {
      return const SizedBox(); // 유효하지 않은 index는 빈 위젯 반환
    }

    final ImageButtonConfig config =
        imageButtonData[index]; // 리스트에서 해당 인덱스의 설정 가져오기

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.5,
            blurRadius: 5,
          )
        ],
      ),
      child: IconButton(
        onPressed: () async => await config.onPressed(notifier),
        icon: Icon(
          config.icon,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}
