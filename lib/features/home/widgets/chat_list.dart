part of '../lib.dart';

class HomeChatList extends ConsumerWidget {
  const HomeChatList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ChatListViewModel notifier =
        ref.read(chatListViewModelProvider.notifier);
    final AsyncValue<ChatListModel> state =
        ref.watch(chatListViewModelProvider);

    // FirebaseAuth 인스턴스에서 현재 사용자 가져오기
    final User? user = FirebaseAuth.instance.currentUser;
    // 현재 사용자가 null인 경우 로그인 화면으로 이동
    if (user == null) {
      return buildNeedLogin(notifier);
    }

    return state.when(
      data: (ChatListModel data) => buildChatRoom(context, data, notifier),
      error: (error, stackTrace) => Container(),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  // 데이터 갯수만큼 채팅방 리스트타일 생성
  Widget buildChatRoom(
      BuildContext context, ChatListModel data, ChatListViewModel notifier) {
    return Column(
      children: [
        ...List<Widget>.generate(data.roomList.length, (i) {
          return buildChatRoomListTile(context, data.roomList[i], notifier);
        }),
      ],
    );
  }

  // 채팅방 리스트타일 위젯
  Widget buildChatRoomListTile(
      BuildContext context, ChatRoomData data, ChatListViewModel notifier) {
    return ListTile(
      title: Row(
        children: [
          const Icon(IconData(0xe153, fontFamily: 'MaterialIcons')),
          MCSpace().horizontalHalfSpace(),
          Text(data.name != '' ? data.name : '제목 없음'),
          const Spacer(),
          GestureDetector(
            child: const Icon(IconData(0xf317, fontFamily: 'MaterialIcons')),
            onTap: () {
              // 현재 사용자가 방의 유일한 멤버인 경우, 방 삭제
              // 삭제 전에 다이얼로그를 띄워 확인
              if (data.members.length == 1) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DeleteChatRoomDialog(
                      onDelete: notifier.deleteChatRoom,
                      roomData: data,
                    );
                  },
                );
                return;
              }
              notifier.deleteChatRoom(data);
            },
          ),
        ],
      ),
      onTap: () {
        Scaffold.of(context).closeDrawer();
        notifier.goChat(data.roomId, data.name);
      },
    );
  }

  Widget buildNeedLogin(ChatListViewModel notifier) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('로그인이 필요합니다.'),
          GestureDetector(
            child: const Text(
              '로그인 하러 가기',
              style: TextStyle(color: Colors.blue),
            ),
            onTap: () => notifier.goLogin(),
          ),
        ],
      ),
    );
  }
}
