import 'package:machat/router/lib.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'floating_button_view_model.g.dart';

@riverpod
class FloatingButtonViewModel extends _$FloatingButtonViewModel {
  final List<String> iconUrl = [
    'lib/assets/icons/chat-plus.svg',
    'lib/assets/icons/enter.svg',
    'lib/assets/icons/person-plus-fill.svg',
  ];
  @override
  void build() async {}

  // 버튼 인덱스에 따른 function 분기자.
  // 0 : 채팅방 만들기
  // 1 : 채팅방 리스트 페이지로 이동
  // 2 : 친구구 추가 페이지로 이동
  Future<void> functionBrancher(int index) async {
    switch (index) {
      case 0:
        return goChatCreate();
      case 1:
        return goChatRoomListPage();
      case 2:
        return goAddFriend();
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

  void goAddFriend() {
    final route = ref.read(goRouterProvider);

    route.goNamed(RouterPath.addFriend.name);
  }
}
