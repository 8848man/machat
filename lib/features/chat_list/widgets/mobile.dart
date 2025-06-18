part of '../lib.dart';

class ChatListMobile extends ConsumerWidget {
  const ChatListMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ChatListViewModel notifier =
        ref.read(chatListViewModelProvider.notifier);
    final AsyncValue<ChatListModel> state =
        ref.watch(chatListViewModelProvider);
    // 상위 위젯 UserChecker에서 nullCheck를 하기 때문에 null이 될 수 없음
    final User? user = FirebaseAuth.instance.currentUser;

    return state.when(
      data: (ChatListModel data) =>
          buildChatRoom(context, data, notifier, user!),
      error: (error, stackTrace) => Container(),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  } // 데이터 갯수만큼 채팅방 리스트타일 생성

  Widget buildChatRoom(BuildContext context, ChatListModel data,
      ChatListViewModel notifier, User user) {
    
    return Column(
      children: [
        ...List<Widget>.generate(data.roomList.length, (i) {
          return buildChatRoomListTile(
              context, data.roomList[i], notifier, user);
        }),
      ],
    );
  }

  // 채팅방 리스트타일 위젯
  Widget buildChatRoomListTile(BuildContext context, ChatRoomData data,
      ChatListViewModel notifier, User user) {
    // 내가 속해있는지 색깔로 드러내는 변수
    final bool isBelong = data.members.contains(user.uid);
    final bool isOwner = user.uid == data.createdBy;

    return ListTile(
      tileColor: GetColor().getPositiveColor(isBelong),
      title: Row(
        children: [
          const Icon(IconData(0xe153, fontFamily: 'MaterialIcons')),
          MCSpace().horizontalHalfSpace(),
          Text(data.name != '' ? data.name : '제목 없음'),
          // 방 소유자일 경우 왕관 출력
          if (isOwner) MCSpace().horizontalHalfSpace(),
          if (isOwner) Image.asset('lib/assets/icons/crown.png', scale: 16),
          const Spacer(),
          Text('인원 수 : ${data.members.length}'),
        ],
      ),
      onTap: () => notifier.enterChat(data),
    );
  }
}
