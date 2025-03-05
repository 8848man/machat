import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:machat/features/chat/expand/view_models/chat_expand_view_model.dart';

class ChatPicture extends ConsumerWidget {
  const ChatPicture({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ChatExpandViewModel notifier =
        ref.read(chatExpandViewModelProvider.notifier);
    final List<XFile?> images = notifier.images;
    return Container(
      margin: const EdgeInsets.all(10),
      child: GridView.builder(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        itemCount: images.length, //보여줄 item 개수. images 리스트 변수에 담겨있는 사진 수 만큼.
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, //1 개의 행에 보여줄 사진 개수
          childAspectRatio: 1 / 1, //사진 의 가로 세로의 비율
          mainAxisSpacing: 10, //수평 Padding
          crossAxisSpacing: 10, //수직 Padding
        ),
        itemBuilder: (BuildContext context, int index) {
          // 사진 오른 쪽 위 삭제 버튼을 표시하기 위해 Stack을 사용함
          return Stack(
            alignment: Alignment.topRight,
            children: [
              buildImageContainer(images, index),
              buildRemoveButton(notifier, index),
            ],
          );
        },
      ),
    );
  }

  Widget buildImageContainer(List<XFile?> images, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        image: DecorationImage(
          fit: BoxFit.cover, //사진을 크기를 상자 크기에 맞게 조절
          image: FileImage(
            File(
              images[index]!.path, // images 리스트 변수 안에 있는 사진들을 순서대로 표시함
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRemoveButton(ChatExpandViewModel notifier, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(5),
      ),
      //삭제 버튼
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        icon: const Icon(Icons.close, color: Colors.white, size: 15),
        onPressed: () async => await notifier.removeImage(index),
      ),
    );
  }
}
