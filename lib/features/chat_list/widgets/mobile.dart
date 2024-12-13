part of '../lib.dart';

class ChatListMobile extends ConsumerWidget {
  const ChatListMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ChatListViewModel notifier =
        ref.read(chatListViewModelProvider.notifier);
    final AsyncValue<ChatListModel> state =
        ref.watch(chatListViewModelProvider);
    final User? user = FirebaseAuth.instance.currentUser;

    // user 객체가 없을 경우 에러 처리
    // 2번 나오는 현상 -> stless 위젯 UserChecker() 만들어서 처리하기
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        toastification.show(
          context: context, // optional if you use ToastificationWrapper
          title: const Text('로그인을 하고 이용해주세요!'),
          autoCloseDuration: const Duration(seconds: 2),
        );
      });
      ref.read(goRouterProvider).goNamed(RouterPath.login.name);
      return Container();
    }

    return state.when(
      data: (ChatListModel data) =>
          buildChatRoom(context, data, notifier, user),
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
          if (isOwner) MCSpace().horizontalHalfSpace(),
          if (isOwner) Image.asset('icons/crown.png', scale: 16),
          const Spacer(),
          Text('인원 수 : ${data.members.length}'),
        ],
      ),
      onTap: () => notifier.enterChat(data.roomId),
    );
  }
}
