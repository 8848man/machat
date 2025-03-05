import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/features/chat/expand/view_models/chat_expand_view_model.dart';

class ChatExpandSelector extends ConsumerStatefulWidget {
  const ChatExpandSelector({super.key});

  @override
  ConsumerState<ChatExpandSelector> createState() => ChatExpandSelectorState();
}

class ChatExpandSelectorState extends ConsumerState<ChatExpandSelector> {
  late ImagePicker picker;
  late XFile? image; // 카메라로 촬영한 이미지를 저장할 변수
  late List<XFile?> multiImage = []; // 갤러리에서 여러장의 사진을 선택해서 저장할 변수
  late List<XFile?> images = []; // 가져온 사진들을 보여주기 위한 변수
  late ChatExpandViewModel notifier;

  @override
  Widget build(BuildContext context) {
    notifier = ref.read(chatExpandViewModelProvider.notifier);
    initPicker();

    return expandAttach();
  }

  void initPicker() {
    final notifier = ref.read(chatExpandViewModelProvider.notifier);
    picker = notifier.picker;
    images = notifier.images;
    multiImage = notifier.multiImage;
    image = notifier.image;
  }

  Widget expandAttach() {
    return Container(
      color: MCColors.$color_grey_10,
      margin: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //카메라로 촬영하기
          getFromCameraButton(),
          //갤러리에서 가져오기
          getFromGalaryButton(),
        ],
      ),
    );
  }

  // 카메라에서 가져오기
  Widget getFromCameraButton() {
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
        onPressed: () async => await notifier.getFromCamera(),
        icon: const Icon(
          Icons.add_a_photo,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }

  // 갤러리에서 가져오기
  Widget getFromGalaryButton() {
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
              blurRadius: 5)
        ],
      ),
      child: IconButton(
        onPressed: () async => await notifier.getFromGalary(),
        icon: const Icon(
          Icons.add_photo_alternate_outlined,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget selectedPictures() {
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
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    fit: BoxFit.cover, //사진을 크기를 상자 크기에 맞게 조절
                    image: FileImage(
                      File(images[index]!
                              .path // images 리스트 변수 안에 있는 사진들을 순서대로 표시함
                          ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(5),
                ),
                //삭제 버튼
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.close, color: Colors.white, size: 15),
                  onPressed: () {
                    //버튼을 누르면 해당 이미지가 삭제됨
                    setState(() {
                      images.remove(images[index]);
                    });
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
