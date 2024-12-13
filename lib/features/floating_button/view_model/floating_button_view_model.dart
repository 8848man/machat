import 'package:machat/router/lib.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'floating_button_view_model.g.dart';

@riverpod
class FloatingButtonViewModel extends _$FloatingButtonViewModel {
  final List<String> iconUrl = ['icons/chat-plus.svg', 'icons/enter.svg'];
  @override
  void build() async {}

  Future<void> functionBrancher(int index) async {
    switch (index) {
      case 0:
        return goChatCreate();
      case 1:
        return goChatRoomListPage();
      default:
        print('invalid index, index is $index');
        return;
    }
  }

  void goChatCreate() {
    final route = ref.read(goRouterProvider);

    route.goNamed(RouterPath.chatCreate.name);
  }

  Future<void> goChatRoomListPage() async {
    final route = ref.read(goRouterProvider);

    route.goNamed(RouterPath.chatList.name);
  }
}
