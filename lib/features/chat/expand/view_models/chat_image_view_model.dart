import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:machat/features/chat/expand/enums/expand_state.dart';
import 'package:machat/features/chat/expand/models/chat_expand_model.dart';
import 'package:machat/features/chat/expand/models/chat_image_list.dart';
import 'package:machat/features/chat/expand/providers/expand_image_state_provider.dart';
import 'package:machat/features/chat/expand/providers/expand_widget_state_provider.dart';
import 'package:machat/features/chat/expand/repositories/chat_image_repository.dart';
import 'package:machat/features/chat/interface/chat_view_model_interface.dart';
import 'package:machat/features/common/providers/chat_room_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_image_view_model.g.dart';

@riverpod
class ChatImageViewModel extends _$ChatImageViewModel
    implements ChatViewModelInterface {
  final picker = ImagePicker();

  @override
  ChatExpandModel build() {
    final XFileList imageState = ref.read(expandImageStateProvider);

    // ImageState를 감지하여 변경.
    // 변경 감지할 때 onDispose 재귀호출 방지
    ref.listen<XFileList>(expandImageStateProvider, (previous, next) {
      if (next.images.isNotEmpty) {
        goToPictureState();
        state = state.copyWith(images: next.images);
      }
    });

    ref.onDispose(() {
      clearImage();
    });

    return ChatExpandModel(images: imageState.images);
  }

  // ----------------Images ------------------
  // 카메라로 가져오기
  Future<void> getFromCamera() async {
    XFile? image = await picker.pickImage(source: ImageSource.camera);
    //카메라로 촬영하지 않고 뒤로가기 버튼을 누를 경우, null값이 저장되므로 if문을 통해 null이 아닐 경우에만 images변수로 저장하도록 합니다
    if (image != null) {
      final currentImages = ref.read(expandImageStateProvider).images;
      // 새로운 리스트 생성 (불변성 유지)
      final updatedImages = List<XFile?>.from(currentImages)..add(image);

      // 상태 업데이트
      ref.read(expandImageStateProvider.notifier).state =
          XFileList(images: updatedImages);
    }
  }

  // 갤러리에서 여러 사진 가져오기
  Future<void> getFromGallary() async {
    List<XFile?> multiImage = await picker.pickMultiImage();
    if (multiImage.isNotEmpty) {
      final currentImages = ref.read(expandImageStateProvider).images;
      // 새로운 리스트 생성 (불변성 유지)
      final updatedImages = List<XFile?>.from(currentImages)
        ..addAll(multiImage);

      // 상태 업데이트
      ref.read(expandImageStateProvider.notifier).state =
          XFileList(images: updatedImages);
      goToPictureState();
    }
  }

  // 이미지 제거
  Future<void> removeImage(int index) async {
    final currentImages = ref.read(expandImageStateProvider).images;

    // 새로운 리스트 생성 (불변성 유지)
    final updatedImages = List<XFile?>.from(currentImages)..removeAt(index);

    // 상태 업데이트
    ref.read(expandImageStateProvider.notifier).state =
        XFileList(images: updatedImages);

    // 이미지가 더 이상 없으면 상태 초기화
    if (updatedImages.isEmpty) {
      resetExpandWidgetState();
    }

    // // 현재 뷰모델 상태도 업데이트
    // state = state.copyWith(images: updatedImages);
  }

  // 모든 이미지 제거
  Future<void> clearImage() async {
    final currentImages = ref.read(expandImageStateProvider).images;

    // 새로운 리스트 생성 (불변성 유지)
    final updatedImages = List<XFile?>.from(currentImages)..clear();

    // 상태 업데이트
    ref.read(expandImageStateProvider.notifier).state =
        XFileList(images: updatedImages);
  }

  // ----------------Images ------------------

  // 확장 위젯 상태 초기화
  // 컨텐츠가 등록되지 않았을 경우 실행
  void resetExpandWidgetState() {
    ref.read(expandWidgetStateProvider.notifier).state =
        ExpandWidgetState.expanded;
  }

  // 사진 페이지로 상태 전환하여 페이지 이동
  void goToPictureState() {
    ref.read(expandWidgetStateProvider.notifier).state =
        ExpandWidgetState.picture;
  }

  Future<void> sendImage() async {
    try {
      // 현재 접속된 유저 아이디 가져오기
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User is not logged in');
      }
      final String userId = currentUser.uid;
      final ChatImageRepository repository =
          ref.read(chatImageRepositoryProvider);
      final String roomId = ref.watch(chatRoomIdProvider);

      final List<XFile?> images = state.images; // ViewModel의 images 가져오기

      if (images.isEmpty) return; // 이미지가 없으면 업로드 X
      // 모든 이미지 업로드를 병렬로 처리
      final List<Future<String?>> uploadTasks = images
          .where((image) => image != null) // null 필터링
          .map((image) => repository.uploadImage(userId, roomId, image!))
          .toList();

      // 모든 업로드가 완료될 때까지 대기
      final List<String?> downloadURLs = await Future.wait(uploadTasks);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> sendData() => sendImage();
}
