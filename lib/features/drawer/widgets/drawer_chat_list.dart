part of '../lib.dart';

class DrawerChatList extends ConsumerWidget {
  const DrawerChatList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MCDrawerViewModel notifier =
        ref.read(mCDrawerViewModelProvider.notifier);
    final AsyncValue<DrawerModel> state = ref.watch(mCDrawerViewModelProvider);
    return state.when(
      data: (DrawerModel data) => buildChatRoom(context, data, notifier),
      error: (error, stackTrace) => Container(),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildChatRoom(
      BuildContext context, DrawerModel data, MCDrawerViewModel notifier) {
    return Column(
      children: [
        ...List<Widget>.generate(data.roomList.length, (i) {
          return buildChatRoomListTile(context, data.roomList[i], notifier);
        }),
      ],
    );
  }

  Widget buildChatRoomListTile(
      BuildContext context, ChatRoomData data, MCDrawerViewModel notifier) {
    return ListTile(
      title: Row(
        children: [
          const Icon(IconData(0xe153, fontFamily: 'MaterialIcons')),
          MCSpace().horizontalHalfSpace(),
          Text(data.name != '' ? data.name : '제목 없음'),
          const Spacer(),
          GestureDetector(
            child: const Icon(IconData(0xf317, fontFamily: 'MaterialIcons')),
            onTap: () => notifier.deleteChatRoom(),
          ),
        ],
      ),
      onTap: () {
        Scaffold.of(context).closeDrawer();
        notifier.goChat(data.roomId);
      },
    );
  }
}
