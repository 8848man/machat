import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_expand_view_model.g.dart';

@riverpod
class ChatExpandViewModel extends _$ChatExpandViewModel {
  final picker = ImagePicker();
  XFile? image; // 카메라로 촬영한 이미지를 저장할 변수
  List<XFile?> multiImage = []; // 갤러리에서 여러장의 사진을 선택해서 저장할 변수
  List<XFile?> images = []; // 가져온 사진들을 보여주기 위한 변수

  @override
  void build() {}

  // 카메라로 가져오기
  Future<void> getFromCamera() async {
    image = await picker.pickImage(source: ImageSource.camera);
    //카메라로 촬영하지 않고 뒤로가기 버튼을 누를 경우, null값이 저장되므로 if문을 통해 null이 아닐 경우에만 images변수로 저장하도록 합니다
    if (image != null) {
      images.add(image);
    }
  }

  Future<void> getFromGalary() async {
    multiImage = await picker.pickMultiImage();
    images.addAll(multiImage);
  }

  Future<void> removeImage(int index) async {
    images.removeAt(index);
  }
}
