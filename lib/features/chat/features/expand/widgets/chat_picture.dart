import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:machat/features/chat/features/expand/models/chat_expand_model.dart';
import 'package:machat/features/chat/features/expand/view_models/chat_image_view_model.dart';

class ChatPicture extends ConsumerWidget {
  const ChatPicture({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ChatImageViewModel notifier =
        ref.read(chatImageViewModelProvider.notifier);
    final ChatExpandModel state = ref.watch(chatImageViewModelProvider);
    // 이미지 세팅
    final List<XFile?> images = state.images;
    return buildGridImageContainer(images: images, notifier: notifier);
  }

  // 그리드 컨테이너 빌드
  Widget buildGridImageContainer({
    required List<XFile?> images,
    required ChatImageViewModel notifier,
  }) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: images.length, //보여줄 item 개수. images 리스트 변수에 담겨있는 사진 수 만큼.
        gridDelegate: gridDelegate(),
        itemBuilder: (BuildContext context, int index) {
          // 사진 오른 쪽 위 삭제 버튼을 표시하기 위해 Stack을 사용함
          return buildImageContainer(
            images: images,
            index: index,
            notifier: notifier,
          );
        },
      ),
    );
  }

  // 그리드 컨테이너 설정
  SliverGridDelegate gridDelegate() {
    return const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3, //1 개의 행에 보여줄 사진 개수
      childAspectRatio: 1 / 1, //사진 의 가로 세로의 비율
      mainAxisSpacing: 10, //수평 Padding
      crossAxisSpacing: 10, //수직 Padding
    );
  }

  // 이미지를 담는 Stack 컨테이너 빌드
  Widget buildImageContainer({
    required List<XFile?> images,
    required int index,
    required ChatImageViewModel notifier,
  }) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        buildImage(images, index),
        buildRemoveButton(notifier, index),
      ],
    );
  }

  // 이미지 컨테이너 빌드
  Widget buildImage(List<XFile?> images, int index) {
    // 모바일과 웹 구분
    if (kIsWeb) {
      return FutureBuilder<Uint8List>(
        future: images[index]!.readAsBytes(), // 이미지를 메모리로 읽기
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading image'));
          } else {
            // 이미지가 정상적으로 로드되었으면 Image.memory로 표시
            return ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.memory(
                snapshot.data!,
                fit: BoxFit.cover,
              ),
            );
          }
        },
      );
    } else {
      // 모바일에서는 FileImage 사용
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: FileImage(
              File(images[index]!.path), // 모바일에서 로컬 파일 경로 사용
            ),
          ),
        ),
      );
    }
  }

  // 이미지 삭제 버튼 빌드
  Widget buildRemoveButton(ChatImageViewModel notifier, int index) {
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
