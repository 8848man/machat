import 'package:flutter/widgets.dart';
import 'package:machat/features/chat_create/models/chat_create_model.dart';
import 'package:machat/features/common/view_models/chat_room_crud_view_model.dart';
import 'package:machat/features/common/widgets/mc_check_box_view.dart';
import 'package:machat/router/lib.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_create_view_model.g.dart';

@riverpod
class ChatCreateViewModel extends _$ChatCreateViewModel {
  TextEditingController roomNameController = TextEditingController();
  @override
  ChatCreateModel build() {
    return const ChatCreateModel();
  }

  void create() {}

  /// 라우팅
  void goHome() {
    final router = ref.read(goRouterProvider);

    router.goNamed(RouterPath.home.name);
  }

  /// 라우팅/

  Future<void> createChatRoomProcess() async {
    final router = ref.read(goRouterProvider);
    ChatRoomType type = ChatRoomType.group;
    final bool isOpenChat = ref.read(checkboxStateProvider.notifier).state;
    if (isOpenChat) {
      type = ChatRoomType.open;
    }
    await ref.read(chatRoomCrudViewModelProvider.notifier).createChatRoom(
          roomName: roomNameController.text,
          type: type,
        );
    // await createChatRoom();

    router.goNamed(RouterPath.home.name);
  }
}
